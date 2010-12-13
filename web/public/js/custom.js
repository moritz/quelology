$(document).ready(function() {
    $('#header').droppable({
        drop: function(ent, ui) {
            var source_id = ui.draggable.attr('id').split('_')[1];
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

function clear_shelf() {
    $.ajax({
        type: 'POST',
        url: '/shelf/delete',
        success: function(response) {
            $('#shelf').html(response);
        }
    });
}
