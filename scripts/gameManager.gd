extends Node2D


var selectedPlayer: Node2D;
var players: Array[Node2D];
const SELECT_RADIUS = 75;
# Called when the node enters the scene tree for the first time.
func _ready():
	#selectedPlayer = get_node("player");
	players.append(get_node("player1"));
	players.append(get_node("player2"));
	pass # Replace with function body.

func set_selected_player(idx):
	if selectedPlayer:
		selectedPlayer.deselect();
	selectedPlayer = players[idx];
	selectedPlayer.select();
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var mouse_pos = get_local_mouse_position()
	if(Input.is_action_just_pressed("goto_click")):
		var just_selected = false;
		#print('looking for ', mouse_pos);
		for i in players.size():
			#print(' in ', players[i].position)
			var player = players[i];
			if (player.position.distance_to(mouse_pos) < SELECT_RADIUS):
				#selectedPlayer = player;
				set_selected_player(i);
				just_selected = true;
				break;
		if selectedPlayer && !just_selected:
			# check if we click any selectedPlayer.player_moves()
			var remove_from_idx = -1;
			for i in selectedPlayer.players_moves.size():
				if(check_if_hovering_point(selectedPlayer.players_moves[i], mouse_pos)):
					# remove all the move farward
					remove_from_idx = i;
					break;
			
			if remove_from_idx != -1:
				selectedPlayer.players_moves = selectedPlayer.players_moves.slice(0, remove_from_idx);
			else:
				selectedPlayer.players_moves.append(mouse_pos);
				selectedPlayer.players_attacks.clear();
	
	if(Input.is_action_just_pressed("attack_click")):
		if selectedPlayer:
			selectedPlayer.set_fire_target(mouse_pos);
	# check is the mouse is hovering over the selectedPlayer moves we set hoverable_move_cancel_index
	if selectedPlayer:
		var hover_index = -1;
		for i in selectedPlayer.players_moves.size():
			if(check_if_hovering_point(mouse_pos, selectedPlayer.players_moves[i])):
				hover_index = i;
		selectedPlayer.hoverable_move_cancel_index = hover_index;
	queue_redraw()
	
func check_if_hovering_point(p1: Vector2, p2:Vector2, rad=35):
	if p1.distance_to(p2) < rad:
		return true;
	return false;
	pass
func _draw():
	if(!selectedPlayer):
		return;
	#draw_circle(selectedPlayer.position, SELECT_RADIUS,Color(0.3,0.7,0.3,0.5))
	var label = Label.new()
	var font = label.get_theme_default_font()
	#print(selectedPlayer.players_moves.size());
	# for each of the moves in the array, draw a circle at that position with the numbwer of the move inside, then a line between the circles to show the order
	for i in selectedPlayer.players_moves.size():
		var mov_pos = selectedPlayer.players_moves[i];
		draw_circle(mov_pos, 35, Color(1, 1, 1));
		var re_center = mov_pos;
		re_center.x -= 35;
		re_center.y += 30;
		var ch = str(i);
		if selectedPlayer.hoverable_move_cancel_index != -1 && selectedPlayer.hoverable_move_cancel_index <= i:
			ch = 'X';
		draw_string(font, re_center, ch,HORIZONTAL_ALIGNMENT_CENTER,72, 72, Color(0,0,0,1))
		if i > 0:
			draw_line(mov_pos, selectedPlayer.players_moves[i-1], Color(0,1,0),4);
		draw_line(selectedPlayer.position, selectedPlayer.players_moves[0], Color(0,1,0),4);
		
	# draw attacks:
	for i in selectedPlayer.players_attacks.size():
		var attack_pos = selectedPlayer.players_attacks[i];
		draw_circle(attack_pos, 35, Color(1, 0, 0,0.4));
		var re_center = attack_pos;
		re_center.x -= 35;
		re_center.y += 30;
		var ch = str(i);
		draw_string(font, re_center, ch,HORIZONTAL_ALIGNMENT_CENTER,72, 72, Color(0,0,0,1))
		#if i > 0:
			#draw_line(attack_pos, selectedPlayer.players_attacks[i-1], Color(1,0,0),4);
		#draw_line(selectedPlayer.position, selectedPlayer.players_attacks[0], Color(1,0,0),4);
