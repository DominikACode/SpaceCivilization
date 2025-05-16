extends Node3D
var player: Node3D
var astar3:=AStar3D.new()
var dictOfPoints :Dictionary={}
var dictOfIds :Dictionary={}
var rng= RandomNumberGenerator.new()
var playerPoint
var playerNeighbors:=[]
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
			if rng.randf()<0.6 :
				var point = preload("res://Star.tscn").instantiate()
				add_child(point)
				point.global_position=Vector3(j*6+rng.randf_range(0,5),0,i*6+rng.randf_range(0,5))
				var rngScale=rng.randf_range(0.25,0.75);
				point.scale=Vector3(rngScale,rngScale,rngScale)
#connects the stars with starlanes 2 per star to the closest neighbors
func connectStars() ->void:
	for point in get_children():
		var pointId:int=astar3.get_available_point_id()
		dictOfPoints[pointId]=point
		dictOfIds[point]=pointId
		astar3.add_point(pointId,point.global_position)
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
		for k in range(2):
			var indexToConnect:=distOfPoints.find(sortedDistOfPoints[k])
			var idToConnect:int= arrOfPoints[indexToConnect]
			if ! astar3.are_points_connected(pointID,idToConnect):
				astar3.connect_points(pointID,idToConnect,true)
				var path = preload("res://path.tscn").instantiate()
				add_child(path)
				path.scale=Vector3(sortedDistOfPoints[k]/2,0.1,0.1)
				path.global_position=pointPosition
				#find rotation angle needed for cylinders then rotate them
				path.rotate_y(-atan2(dictOfPoints[idToConnect].position.z-path.position.z,dictOfPoints[idToConnect].position.x-path.position.x))
func placePlayer() ->void:
	var points:=[]
	points=astar3.get_point_ids()
	playerPoint=points.pick_random()
	playerNeighbors=astar3.get_point_connections(playerPoint)
	player.global_position= astar3.get_point_position(playerPoint)
func _input(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		mouse=event.position
	if event is InputEventMouseButton and event.is_pressed()==false and event.button_index==MOUSE_BUTTON_LEFT:
		mouseIntersection(mouse)
# raycast mouse position detection (only detects colision objects)
func mouseIntersection(mouse:Vector2):
	var space=get_world_3d().direct_space_state
	var start=get_viewport().get_camera_3d().project_ray_origin(mouse)
	var end=start + get_viewport().get_camera_3d().project_ray_normal(mouse) * 1000
	var params=PhysicsRayQueryParameters3D.new()
	params.from=start
	params.to=end
	var result=space.intersect_ray(params)
	if result.is_empty()==false:
		print(result)
		for i in playerNeighbors:
			if i==astar3.get_closest_point(result.position):
				playerPoint=i
				playerNeighbors=astar3.get_point_connections(playerPoint)
				player.move(astar3.get_point_position(playerPoint))
