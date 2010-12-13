$(document).ready(function() {
    $('#header').droppable({
        drop: function(ent, ui) {
            var source_id = ui.draggable.attr('id').split('_')[1];
//            alert("Dropping " + source_id + " onto the #header area");
            $.ajax({
                type: 'POST',
                url:  '/shelf/add',
                data: {
                    id: source_id
                },
                success: function(response) {
                    $('#shelf').html(response);
                }
            })
        }
    });
});
