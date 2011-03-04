function add_id_to_shelf(source_id) {
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

function edit_medium(id) {
    var span = $('#medium_' + id);
    var cancel = span.html();
    var link = $(span.children('a')[0]);
    var input_id = 'title_' + id;
    var form = $('<form action="/update/title" method="post"></form>').attr('id', 'form_changetitle_' + id);
    var input = $('<input></input>').attr('name', 'title').attr('id', 'input_title_' + id).attr('value', link.text());
    form.append(input);
    input = $('<input></input>').attr('type', 'submit').attr('value', 'Do it!');
    form.append(input);
    input = $('<input>').attr('value', 'cancel').attr('type', 'button').click(function() {
        span.html(cancel);
    });
    form.append(input);

    form.submit(function(e) {
        var new_title = $('#input_title_' + id).attr('value');
        if (new_title == '') {
            alert('Cannot submit with empty title');
            return false;
        }
        $.ajax({
            type: 'POST',
            url: '/update/title',
            data: {
                "id": id,
                title: new_title
            },
            success: function(response) {
                span.replaceWith(response);
            }
        });
        // TODO: intercept form submission to do it AJAX-y
        return false;
    });

    link.replaceWith(form);
}

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
            $('#source_id' ).val(ui.draggable.attr('id').split('_')[1]);
            $('#edit_where').val(target_spec[1]);
            $('#target_id' ).val(target_spec[2]);
            $('#edit_form' ).submit();
        }
    });

    $('.shelf-droppable').droppable({
        drop: function(ent, ui) {
            var source_id = ui.draggable.attr('id').split('_')[1];
            add_id_to_shelf(source_id);
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
