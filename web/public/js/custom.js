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

function recompute_medium(what, id) {
    $.ajax({
        type: 'POST',
        url: '/recompute/' + what,
        data: {
            id: id
        },
        success: function(response) {
            install_draggable($('#medium_' + id).replaceWith(response));
        }
    });
}

function update_medium(id, what) {
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
                install_draggable(span);
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
            var r = $(response);
            install_draggable(r);
            container.replaceWith(r);
        }
    });
}

function create_medium(id, where) {
    // TODO: show dialog prompting for title and authors
    // then send an ajaxy request
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
            var r = $(response);
            install_draggable(r);
            container.replaceWith(response);
        }
    });
}

function install_draggable(what) {
    var drag_data = {
        snap: ".droppable",
        snapMode: 'inner',
        cursorAt: { top: 8, left: 8 },
        helper: function (event) {
            return $( '<img src="/image/drag-small.png" >' );
        }
    };
    $(what).find('.medium').draggable(drag_data);
    $(what).find('.medium').contents().draggable(drag_data);
}

$(document).ready(function() {
    install_draggable(document);
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
            var source_id = ui.draggable.attr('data-id');
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
