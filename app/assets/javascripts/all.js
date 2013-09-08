var filter_params;

$(document).ready(function () {
    //fixed_sidebar();

    //update_unread_counter();
    ui_init();
    wysiwyg_editor();

    ajax_setup();
    ajax_pagination();

    filter_helpers();

    flash_animations();
    collapse_sections();
    hilight_cocoon_nested_fields();
});


function ui_init() {
    // use handle cursor for elements that can move
    $(".handle").hover(
        function () {
            $(this).addClass("move");
        },
        function () {
            $(this).removeClass("move");
        }
    );
    // hilight when deleted icon is selected
    $("li a.delete").live({
        mouseover:function () {
            $(this).closest("li").addClass('hilight');
        },
        mouseout:function () {
            $(this).closest("li").removeClass('hilight');
        }
    });
    // fancy_box on links with preview
    $("a.preview").fancybox();

    // hilight closest comments when link deleted is selected
    hilightClosest("a.delete", "div.comment");
}

function fixed_sidebar() {
    var sidebar = $("section#sidebar");
    var offset = sidebar.offset();
    var topPadding = 15;
    $(window).scroll(function () {
        if (sidebar.height() < $(window).height() && $(window).scrollTop() > offset.top) {
            sidebar.stop().animate({
                marginTop:$(window).scrollTop() - offset.top + topPadding
            });
        } else {
            sidebar.stop().animate({
                marginTop:0
            });
        }
        ;
    });
}

function _update_unread_counter() {
    $.get('/unread_count', function (data) {
        $('span.unread_counter').remove();
        $('li.unread_counter').prepend(data);
    });
}


function update_unread_counter() {
    ajax_service("/ajax/unread_count", function (data) {
        $('span.unread_count').remove();
        var html = '<span class="unread_count">' + data.unread_count + '</span>';
        $('#unread_count').prepend(html);
    });
}

function ajax_service(url, success) {
    $.ajax({
        url:url,
        dataType:"json",
        success:function (data, status, req) {
            success(data);
        },
        error:function (req, status, error) {
            //setFormErrors(form, req);
        }
    });
}

// setup ajax
function ajax_setup() {
    var on = $("#main");
    var loader = $("section#page");

    // ajax spinner
    on.ajaxSend(function () {
        loader.addClass("wait");
    });

    on.ajaxStop(function () {
        loader.removeClass("wait");
        ajax_finalizer();
    });

    // ajax actions
    $('.action a').live("click", function () {
        $(this).html(".....");
    });
}

// add ajax to paginations
function ajax_pagination() {
    // setup data-remote for page links
    $('.pagination a').attr('data-remote', 'true');

    // onclick setup container for ajax indicator
    $('.pagination a').live("click", function () {
        $(this).html(".....");
    });
}

// after finalize an ajax call
function ajax_finalizer() {
    // re-setup data-remote again
    $('.pagination a').attr('data-remote', 'true');
    // rebind fancybox
    $("a.preview").fancybox();
    // hilight search results
    var search = $("#search").val();
    if (search) {
        $(".container").highlight(search, 1, "hilight");
    }
}

function wysiwyg_editor() {
    var editor_options = {
        initialContent:"",
        rmUnusedControls:true,
        autoGrow:true,
        initialMinHeight: 60,
        controls:{
            bold:{ visible:true },
            italic:{ visible:true },
            insertOrderedList:{ visible:true },
            insertUnorderedList:{ visible:true },
            removeFormat:{ visible:false }
        },
        css:'/assets/editor.css'
    };
    //$(".editor").each(function () {
    //    $(this).wysiwyg(editor_options);
    //});

    var editor_full = $.extend(editor_options, {
            iFrameClass:"editor_full",
            initialContent:"" }
    );
    //$(".editor_full").each(function () {
    //    $(this).wysiwyg(editor_options);
    //});

    $(".editor").wysiwyg(editor_options);
    $(".editor_full").wysiwyg(editor_full);
}

// on load do animations for flash messages
function flash_animations() {
    if ($('#notify > div').length > 0) {
        $('#notify').show();
    }

    $('#flash').delay(500).fadeIn('normal', function () {
        $(this).delay(4000).fadeOut('normal', function () {
            $(this).hide();
            $('#notify').hide();
        });
    });
}

// get flash messages as json
// use in .js flash_messages('<%= raw flash.to_json %>');
function flash_messages(json) {
    try {
        var flash = $.parseJSON(json);
        if (flash) {
            if (flash.notice) {
                $('#flash').html(flash.notice);
                $('#flash').addClass("flash_notice");
                $('#flash').delay(500).fadeIn('normal', function () {
                    $(this).delay(3000).fadeOut();
                });
            }
        }
    } catch (e) {
    }
}

function collapse_sections() {
    $('section#page div.inputs').find('h2').click(function () {
        $(this).toggleClass('active').next('div.s_hide').toggle();
        return false;
    });
}

// Hilight nested fields
function hilight_cocoon_nested_fields() {
    // cocoon
    $("a.add_fields").data("association-insertion-position", "before");
    $("a.add_fields").data("association-insertion-node", "this");

    $("a.remove_fields").live({
        mouseover:function () {
            $(this).closest("div.nested-fields").addClass('hilight');
        },
        mouseout:function () {
            $(this).closest("div.nested-fields").removeClass('hilight');
        }
    });
}


function filter_helpers() {
    $("#filter_company").change(function () {
        filter_call({company:$(this).val()}, null);
    });
    $("#filter_category").change(function () {
        filter_call({category:$(this).val()}, null);
    });
}

function filter_call(params, element) {
    filter_params = $.extend(filter_params, params);
    filter_params = clear_filter(filter_params);
    $(element).parents('ul').children('li').children('a').removeClass('filter_on');
    $(element).addClass("filter_on");
    console.log(filter_params);
    $.ajax({
        type:'get',
        url:window.location,
        data:filter_params,
        dataType:'script'
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

