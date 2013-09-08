// Sortable lists
function acts_as_sortable(id, url) {
    $(id).sortable({
        dropOnEmpty: false,
        handle: '.handle',
        placeholder: 'hilight',
        cursor: 'move',
        items: 'li',
        scroll: true,
        update: function() {
            $.ajax({
                type: 'post',
                data: $(id).sortable('serialize'),
                dataType: 'script',
                complete: function(request) {
                    $(id).effect('highlight');
                },
                url: url })
        }
    });
}

function acts_as_editable(id, url) {
    $(id).editable(url, {
        indicator : "<img src='/assets/forms/indicator.gif'>",
        cssclass: 'entry_form',
        width: '150px',
        tooltip : 'edit',
        style : 'inherit'
    });
}

function acts_as_view_calendar(id, url) {
    $(id).fullCalendar({
        editable: false,
        header: {
            left: 'prev,next',
            center: 'title',
            right: '' //'month,agendaWeek,agendaDay'
        },
        defaultView: 'month',
        height: 500,
        slotMinutes: 30,
        loading: function(bool) {
            if (bool)
                $('#loading').show();
            else
                $('#loading').hide();
        },
        events: url,
        timeFormat: 'h:mm t{ - h:mm t} ',
        dragOpacity: "0.5",
        firstDay: 1,
        eventClick: function(event, jsEvent, view) {
            showEventDetails(event);
        }
    });
}

function update_view_calendar(id) {
    $(id).fullCalendar('removeEventSource',calendar_src);
    $(id).fullCalendar('addEventSource',window.location.href);
    $(id).fullCalendar('refetchEvents');
}