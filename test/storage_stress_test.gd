extends Node2D


var offset := 0

@export var email := ""
@export var password := ""


func _ready() -> void:
    Firebase.Auth.login_with_email_and_password(email, password)
    await Firebase.Auth.login_succeeded
    print("Logged in!")

    var ref = Firebase.Storage.ref("test/test_image0.png")
    var task = ref.put_file("res://icon.png")
    task.connect("task_finished", Callable(self, "_on_task_finished").bind(task))

    for i in range(10):
        task = ref.get_data()
        task.connect("task_finished", Callable(self, "_on_task_finished").bind(task))

    task = ref.delete()
    task.connect("task_finished", Callable(self, "_on_task_finished").bind(task))


func _on_task_finished(task: StorageTask) -> void:
    if task.result or task.response_code >= 400:
        if typeof(task.data) == TYPE_DICTIONARY:
            printerr(task.data)
        else:
            var test_json_conv = JSON.new()
            test_json_conv.parse(task.data.get_string_from_utf8()).result)
            printerr(test_json_conv.get_data()
        return

    match task.action:
        StorageTask.Task.TASK_UPLOAD:
            print("%s uploaded!" % task.ref)

        StorageTask.Task.TASK_DOWNLOAD:
            var image := Image.new()
            image.load_png_from_buffer(task.data)
            var tex := ImageTexture.new()
            tex.create_from_image(image)

            var sprite := Sprite2D.new()
            sprite.scale *= 0.7
            sprite.centered = false
            sprite.texture = tex
            sprite.position.x = offset
            add_child(sprite)
            offset += 100

        StorageTask.Task.TASK_DELETE:
            print("%s deleted!" % task.ref)
