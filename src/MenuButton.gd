extends Button

func _on_Menu_Button_mouse_entered():
	$Label.set("custom_colors/font_color", Color(240, 120, 96, 1))


func _on_Menu_Button_mouse_exited():
	$Label.set("custom_colors/font_color", null)
