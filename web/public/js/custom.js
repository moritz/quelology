$(document).ready(function() {
    $('.medium').draggable({
        snap: ".droppable",
        snapMode: 'inner',
        cursorAt: { top: 16, left: 16 },
        helper: function (event) {
            return $( '<img src="/image/drag.png" >' );
        }
    });
    $('.droppable').droppable({
        drop: function (event, ui) {
            var target_spec = $(this).attr('id').split('_');
            var source_id = ui.draggable.attr('id').split('_')[1];
            $('#source_id').val(ui.draggable.attr('id').split('_')[1]);
            $('#edit_where').val(target_spec[1]);
            $('#target_id').val(target_spec[2]);
            $('#edit_form').submit();
        }
    });

    $('.shelf-droppable').droppable({
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
