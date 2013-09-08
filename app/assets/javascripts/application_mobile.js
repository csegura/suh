var filter_params;

$(document).ready(function() {
    console.log("*** document ready");
    filter_helpers();
});

$('#main').live('pageshow', function(event) {
    console.log("** fired");
    //filter_helpers();
});


function filter_helpers() {
    $("#filter_activity").live('change', function() {
        console.log("== activity");
        filter_call({activity: $(this).val(), page: 1}, null);
    });
    $("#filter_company").change(function() {
        filter_call({company: $(this).val()}, null);
    });
    $("#filter_category").change(function() {
        filter_call({category: $(this).val()}, null);
    });
    console.log("** filters")
}

function filter_call(params, element) {
    console.log("*** filter_call")
    filter_params = $.extend(filter_params, params);
    filter_params = clear_filter(filter_params);
    //$(element).parents('ul').children('li').children('a').removeClass('filter_on');
    //$(element).addClass("filter_on");
    $.mobile.changePage('#', {
        data: filter_params,
        transition: 'slidedown',
        type: 'get',
        reverse: false,
        changeHash: false,
        reloadPage: false
    });
}

function clear_filter(params) {
    var filter = {};
    for (var property in params) {
        console.log(params[property]);
        if (property == '_' ||
            params[property] == 'all' ||
            params[property] == '' ||
            params[property] == null) {
        }
        else
            filter[property] = params[property];
    }
    return filter;
}