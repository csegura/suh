// effects used in hidden forms
function app_show(div_class) {
    $('div.' + div_class).delay(300).fadeIn('normal');
}
function app_hide(div_class) {
    $('div.' + div_class).delay(1000).fadeOut('normal');
}

function app_showd(div_id) {
    $('div#' + div_id).delay(300).fadeIn('normal');
}
function app_hided(div_id) {
    $('div#' + div_id).delay(1000).fadeOut('normal');
}

// after create (used in hidden forms)
function after_create(id) {
    $("#" + id + "_form").clearForm();
    $("#" + id + "_form").hide();
    $(".no_data").hide();
}

// get flash messages as json
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

function hilightClosest(element, closest) {
    $(element).live("mouseover mouseout",
        function (event) {
            if (event.type == "mouseover") $(this).closest(closest).addClass("hilight");
            else $(this).closest(closest).removeClass("hilight");
        });
}

(function ($) {
    // clear form data
    $.fn.clearForm = function () {
        return this.each(function () {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag == 'form')
                return $(':input', this).clearForm();
            if (type == 'text' || type == 'password' || tag == 'textarea')
                this.value = '';
            else if (type == 'checkbox' || type == 'radio')
                this.checked = false;
            else if (tag == 'select')
                this.selectedIndex = -1;
            return true;
        });
    };

})(jQuery);

function update_select(name, url, id, blank) {
    if (typeof blank == "undefined") {
        blank = true;
    }
    var select_id = "select#" + name;
    if (id == 0) id = "0";
    jQuery.get(url + id, function (data) {
        $(select_id + " option").remove();
        //put in a empty default line
        if (blank) {
            var row = "<option value=\"" + "" + "\">" + "" + "</option>";
            $(row).appendTo(select_id);
        }
        // Fill sub category select
        $.each(data, function (i, j) {
            console.log(j);
            row = "<option value=\"" + j[1] + "\">" + j[0] + "</option>";
            $(row).appendTo(select_id);
        });
    });
}

function show_optional_form_div(divName, activatorControl, showDiv, initHide) {
    if (showDiv && initHide) {
        $(divName).hide();
        $(activatorControl).attr('checked', false);
    }
    $(activatorControl).click(function () {
        if ($(activatorControl).is(':checked')) {
            if (showDiv) $(divName).show();
            $(divName + ' :input').attr('disabled', false);
        } else {
            $(divName + ' :input').attr('disabled', true);
            if (showDiv) $(divName).hide();
        }
    });
}

function hide_optional_form_div(divName, activatorControl, showDiv, initHide) {
    if (showDiv && initHide) {
        $(divName).hide();
        $(activatorControl).attr('checked', false);
    }
    $(activatorControl).click(function () {
        if ($(activatorControl).is(':checked')) {
            if (showDiv) $(divName).hide();
            $(divName + ' :input').attr('disabled', true);
        } else {
            $(divName + ' :input').attr('disabled', false);
            if (showDiv) $(divName).show();
        }
    });
}
