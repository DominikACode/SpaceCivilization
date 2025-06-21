extends Node3D
var player: Node3D
var astar3:=AStar3D.new()
var dictOfPoints :Dictionary={}
var dictOfIds :Dictionary={}
var rng= RandomNumberGenerator.new()
var playerPoint
var mouse=Vector2()
func _ready() -> void:
	randomize()
	player=get_parent().get_node("Player")
	makeMap()
func makeMap() -> void:
	placeStars()
	connectStars()
	placePlayer()
#creates a semi randomized grid of stars with 40% of grid members missing and random sizes
func placeStars() -> void:
	for i in range(15):
		for j in range(15):
			if rng.randf()<0.7 :
				var point = preload("res://Star.tscn").instantiate()
				add_child(point)
				point.global_position=Vector3(j*4+rng.randf_range(0,3),0,i*6+rng.randf_range(0,3))
				var rngScale=rng.randf_range(0.2,0.6);
				point.scale=Vector3(rngScale,rngScale,rngScale)
#connects the stars with starlanes 2 per star to the closest neighbors
func connectStars() ->void:
	#creates two dictionaries one where you can use point id to get the point object one where you can use to object to get the id
	for point in get_children():
		var pointId:int=astar3.get_available_point_id()
		dictOfPoints[pointId]=point
		dictOfIds[point]=pointId
		astar3.add_point(pointId,point.global_position)
	#loops through the points and ids to make connections
	for pointID in astar3.get_point_ids():
		var connections:= []
		var pointPosition:= astar3.get_point_position(pointID)
		var arrOfPoints:=[]
		var distOfPoints:=[]
		#loops through all points to get distances
		for secondPointId in astar3.get_point_ids():
			if secondPointId != pointID:
				var secondPointPosition :Vector3= dictOfPoints[secondPointId].global_position
				var dist:=pointPosition.distance_to(secondPointPosition)
				distOfPoints.append(dist)
				arrOfPoints.append(secondPointId)
		var sortedDistOfPoints:= distOfPoints.duplicate()
		#sorts points by distance
		sortedDistOfPoints.sort()
		#finds three closest points and attempts to make links
		for k in range(3):
			var indexToConnect:=distOfPoints.find(sortedDistOfPoints[k])
			var idToConnect:int= arrOfPoints[indexToConnect]
			#if the angle is too close to another link a point has the link will not be made to prevent visual clutter
			if smallestAngleBetweenPoints(pointID,idToConnect)>0.2:
				astar3.connect_points(pointID,idToConnect,true)
				#spawns stretches and rotates path objects to visually reprisent connections
				var path = preload("res://path.tscn").instantiate()
				add_child(path)
				path.scale=Vector3(sortedDistOfPoints[k]/2,0.05,0.05)
				path.global_position=pointPosition
				#find rotation angle needed for cylinders then rotate them
				path.rotate_y(-atan2(dictOfPoints[idToConnect].position.z-path.position.z,dictOfPoints[idToConnect].position.x-path.position.x))
func placePlayer() ->void:
	#places player and starting colony ship on a random point
	var points:=[]
	points=astar3.get_point_ids()
	playerPoint=points.pick_random()
	player.global_position= astar3.get_point_position(playerPoint)
	var startingShip = preload("res://SpaceShip.tscn").instantiate()
	add_child(startingShip)
	startingShip.position=astar3.get_point_position(playerPoint)
func smallestAngleBetweenPoints(pointIn,pointTo)->float:
	#finds smalest angle in radians between any and all connections and the new one that is yet to be formed
	var smallestAngle:=2
	var pointsToTest=astar3.get_point_connections(pointIn)
	for point in pointsToTest:
		var BA = astar3.get_point_position(point) - astar3.get_point_position(pointIn)
		var BC = astar3.get_point_position(pointTo) - astar3.get_point_position(pointIn)
		if smallestAngle> BA.angle_to(BC):
			smallestAngle = BA.angle_to(BC)
	return smallestAngle
