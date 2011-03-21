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
                    $('#title_' + id).text($.trim(new_val.text()));
                };
            }
        };
        spec["data"] = data;
        $.ajax(spec);
        return false;
    });

    thing.replaceWith(form);
}

function delete_medium(id) {
    $.ajax({
        type: 'POST',
        url: '/delete',
        data: {
            id: id
        },
        success: function(response) {
            var container = $('#medium_' + id).parents('div.whole_tree');
            container.replaceWith(response);
        }
    });
}

function dissolve_tree(id) {
    $.ajax({
        type: 'POST',
        url: '/dissolve',
        data: {
            id: id
        },
        success: function(response) {
            var container = $('#medium_' + id).parents('div.whole_tree');
            container.replaceWith(response);
        }
    });
}

function install_draggable(what) {
    $(what).find('.medium').draggable({
        snap: ".droppable",
        snapMode: 'inner',
        cursorAt: { top: 8, left: 8 },
        helper: function (event) {
            return $( '<img src="/image/drag-small.png" >' );
        }
    });
}

$(document).ready(function() {
    install_draggable(document);
//    $('.medium').children().draggable({
//        snap: ".droppable",
//        snapMode: 'inner',
//        cursorAt: { top: 16, left: 16 },
//        helper: function (event) {
//            return $( '<img src="/image/drag-small.png" >' );
//        }
//    });
    $('.droppable').droppable({
        drop: function (event, ui) {
            var source_id = ui.draggable.attr('data-id');
            if (!source_id) {
                source_id = ui.draggable.parents('*[data-id]').attr('data-id');
            }
            $('#source_id' ).val(source_id);
            $('#edit_where').val($(this).attr('data-where'));
            $('#target_id' ).val($(this).attr('data-id'));
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
