@tool
## The base class for every document exporter.
## @contribute https://placeholder_contribute.com
class_name DocExporter
extends RefCounted


## @virtual
## @args doc
## @arg-types ClassDocItem
## This function gets called to generate a document string from a [ClassDocItem].
func _generate(doc: ClassDocItem) -> String:
	return ""
