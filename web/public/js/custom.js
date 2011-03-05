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

function update_medium(id, what) {
//    alert('updating ' + what + ' of ' + id);
    var span = $('#medium_' + id);
    var cancel = span.html();
    var thing = $(span.children('.data_' + what)[0]);
    var combined =  what + '_' + id;
    var form = $('<form>').attr('id', 'form_' + combined);
    var input = $('<input>').attr('id', 'input_' + combined).attr('value', $.trim(thing.text()));
    form.append(input);
    input = $('<input>').attr('type', 'submit').attr('value', 'Do it!');
    form.append(input);
    input = $('<input>').attr('type', 'button').attr('value', 'cancel').click(function() {
        span.html(cancel);
    });
    form.append(input);

    form.submit(function(e) {
        var new_value = $('#input_' + combined).attr('value');
        if (new_value == '') {
            return false;
        }
        var data = { "id": id };
        data[what] = new_value;
        var spec = {
            type: 'POST',
            url: '/update/' + what,
            success: function(response) {
                span.replaceWith(response);
                span = $('#medium_' + id);
                var new_val = $(span.children('.data_' + what)[0]);
                if ( span.attr('data-treeposition') == 'root') {
                    $('.root_' + what).text($.trim(new_val.text()));
                };
            }
        };
        spec["data"] = data;
        $.ajax(spec);
        return false;
    });

    thing.replaceWith(form);
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
//    $('.medium').children().draggable({
//        snap: ".droppable",
//        snapMode: 'inner',
//        cursorAt: { top: 16, left: 16 },
//        helper: function (event) {
//            return $( '<img src="/image/drag.png" >' );
//        }
//    });
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
