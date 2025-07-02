extends Node3D
var player: Node3D
var astar3:=AStar3D.new()
var dictOfPoints :Dictionary={}
var dictOfIds :Dictionary={}
var dictPlanetNames :Dictionary={}
var rng= RandomNumberGenerator.new()
var playerPoint
var mouse=Vector2()



var planet_names = [
	"Aelion", "Zarenth", "Velthar", "Novera", "Xandria", "Elyra", "Korith", "Virelia", "Jarnis", "Orvion",
	"Thalor", "Quorra", "Icaron", "Zebulon", "Draveth", "Solith", "Astrix", "Miralon", "Vantaris", "Ephora",
	"Galtris", "Nyvora", "Xenthia", "Tarnok", "Olydria", "Caelus", "Seraphis", "Nymara", "Arkion", "Zephira",
	"Lunaris", "Myrris", "Valtora", "Chronar", "Karnix", "Obrion", "Zurelia", "Thraxon", "Vordis", "Ethra",
	"Virex", "Nixora", "Helvar", "Cyndora", "Talveth", "Zarneth", "Illarion", "Kavros", "Phalorn", "Eronis",
	"Drelath", "Velun", "Straxis", "Omberon", "Virell", "Orthon", "Ythra", "Calmaris", "Zendros", "Ulvira",
	"Lorthax", "Ivenor", "Fornix", "Gelaris", "Quintar", "Obrath", "Talmera", "Iskira", "Thalra", "Ceyrion",
	"Bryndar", "Volaris", "Endralis", "Sarthor", "Tavros", "Yllith", "Elyon", "Dronex", "Valaris", "Zyphron",
	"Theron", "Marentha", "Onyxar", "Zanthea", "Kryon", "Velkris", "Syrath", "Moltar", "Vireth", "Quorath",
	"Jethron", "Yendara", "Phorix", "Eldoria", "Soltrix", "Orryx", "Haleth", "Gavros", "Nythera", "Xolara",
	"Drakonis", "Sytherion", "Varinox", "Isanthar", "Crythra", "Ephion", "Volthar", "Ombrath", "Zephron", "Tarnis",
	"Korvath", "Rynex", "Myrrion", "Therra", "Aeronis", "Nirath", "Varnor", "Glyther", "Osmara", "Telveth",
	"Zirion", "Luneth", "Xeraphis", "Darnor", "Ulthera", "Cynara", "Morath", "Selion", "Karion", "Nyxaris",
	"Tharnis", "Velthira", "Polaris", "Arkara", "Illyra", "Zyndros", "Evion", "Ytheris", "Skirion", "Maltrax",
	"Zerion", "Faylora", "Corthis", "Valkaris", "Drynth", "Irralis", "Sorion", "Eryndor", "Tarneth", "Alvaron",
	"Yvarra", "Grenthis", "Zytheron", "Quillan", "Xevion", "Zaralis", "Niralis", "Gorthar", "Myrralis", "Trivon",
	"Jorvan", "Dysora", "Thryon", "Xeltrix", "Karenth", "Olvaris", "Urythra", "Varkon", "Nemphis", "Silvaron",
	"Yzthera", "Krelon", "Asmaris", "Evrion", "Kelthar", "Phyrion", "Zandros", "Velthora", "Ultrax", "Arthenor",
	"Zoltrix", "Krythos", "Varneth", "Thandros", "Myrrik", "Seldara", "Aurexis", "Zelmaris", "Xyrentha", "Lorvax",
	"Omthar", "Tyrron", "Vinthos", "Carthra", "Melvaris", "Nythros", "Gelvaron", "Orlaxis", "Thaltrix", "Xandros"
]


func _ready() -> void:
	randomize()
	player=get_parent().get_node("Player")
	makeMap()

func makeMap() -> void:
	placeStars()
	connectStars()
	placePlayer()

func placeStars() -> void:
	for i in range(15):
		for j in range(15):
			if rng.randf() < 0.7 :
				if planet_names.size() == 0:
					push_warning("Brak unikalnych nazw planet!")
					return
				var point = preload("res://scenes/Star.tscn").instantiate()
				add_child(point)
				point.global_position=Vector3(j*4+rng.randf_range(0,3),0,i*6+rng.randf_range(0,3))
				var rngScale=rng.randf_range(0.2,0.6);
				point.scale=Vector3(rngScale,rngScale,rngScale)

				var randIndex = rng.randi_range(0, planet_names.size() - 1)
				var chosenName = planet_names[randIndex]
				planet_names.remove_at(randIndex)

				var pointId:int=astar3.get_available_point_id()
				dictOfPoints[pointId]=point
				dictOfIds[point]=pointId
				dictPlanetNames[pointId] = chosenName
				astar3.add_point(pointId,point.global_position)

				if "planet_id" in point:
					point.planet_id = chosenName
					point.apply_name()

					
				else:
					point.set("planet_id", chosenName)
				#genereting the slots for buildings
				var slots: Array = []
				var arraySize : int = rng.randi_range(5, 12)
				slots.resize(arraySize)
				slots.fill(0)
				point.building_slots = slots
				

func connectStars() ->void:
	for pointID in astar3.get_point_ids():
		var connections:= []
		var pointPosition:= astar3.get_point_position(pointID)
		var arrOfPoints:=[]
		var distOfPoints:=[]
		for secondPointId in astar3.get_point_ids():
			if secondPointId != pointID:
				var secondPointPosition :Vector3= dictOfPoints[secondPointId].global_position
				var dist:=pointPosition.distance_to(secondPointPosition)
				distOfPoints.append(dist)
				arrOfPoints.append(secondPointId)
		var sortedDistOfPoints:= distOfPoints.duplicate()
		sortedDistOfPoints.sort()
		for k in range(3):
			var indexToConnect:=distOfPoints.find(sortedDistOfPoints[k])
			var idToConnect:int= arrOfPoints[indexToConnect]
			if smallestAngleBetweenPoints(pointID,idToConnect)>0.2:
				astar3.connect_points(pointID,idToConnect,true)
				var path = preload("res://scenes/path.tscn").instantiate()
				add_child(path)
				path.scale=Vector3(sortedDistOfPoints[k]/2,0.05,0.05)
				path.global_position=pointPosition
				path.rotate_y(-atan2(dictOfPoints[idToConnect].position.z-path.position.z,dictOfPoints[idToConnect].position.x-path.position.x))

func placePlayer() ->void:
	var points:=[]
	points=astar3.get_point_ids()
	playerPoint=points.pick_random()
	player.global_position= astar3.get_point_position(playerPoint)
	var startingShip = preload("res://scenes/SpaceShip.tscn").instantiate()
	add_child(startingShip)
	startingShip.position=astar3.get_point_position(playerPoint)

func smallestAngleBetweenPoints(pointIn,pointTo)->float:
	var smallestAngle:=2
	var pointsToTest=astar3.get_point_connections(pointIn)
	for point in pointsToTest:
		var BA = astar3.get_point_position(point) - astar3.get_point_position(pointIn)
		var BC = astar3.get_point_position(pointTo) - astar3.get_point_position(pointIn)
		if smallestAngle> BA.angle_to(BC):
			smallestAngle = BA.angle_to(BC)
	return smallestAngle
