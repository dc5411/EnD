(function ($) {

    $('#boss_selector').parent().append('<ul class="list-item" id="newboss_selector" name="boss_selector"></ul>');
    $('#boss_selector option').each(function () {
        $('#newboss_selector').append('<li value="' + $(this).val() + '">' + $(this).text() + '</li>');
    });
    $('#boss_selector').remove();
    $('#newboss_selector').attr('id', 'boss_selector');
    $('#boss_selector li').first().addClass('init');
    $("#boss_selector").on("click", ".init", function () {
        $(this).closest("#boss_selector").children('li:not(.init)').toggle();
    });
    var allOptions0 = $("#boss_selector").children('li:not(.init)');
    $("#boss_selector").on("click", "li:not(.init)", function () {
        allOptions0.removeClass('selected');
        $(this).addClass('selected');
        $("#boss_selector").children('.init').html($(this).html());
        $("#boss_sel").val($(this).html());
        allOptions0.toggle();
    });

    $('#ascii_selector').parent().append('<ul class="list-item" id="newascii_selector" name="ascii_selector"></ul>');
    $('#ascii_selector option').each(function () {
        $('#newascii_selector').append('<li value="' + $(this).val() + '">' + $(this).text() + '</li>');
    });
    $('#ascii_selector').remove();
    $('#newascii_selector').attr('id', 'ascii_selector');
    $('#ascii_selector li').first().addClass('init');
    $("#ascii_selector").on("click", ".init", function () {
        $(this).closest("#ascii_selector").children('li:not(.init)').toggle();
    });
    var allOptions = $("#ascii_selector").children('li:not(.init)');
    $("#ascii_selector").on("click", "li:not(.init)", function () {
        allOptions.removeClass('selected');
        $(this).addClass('selected');
        $("#ascii_selector").children('.init').html($(this).html());
        $("#ascii_sel").val($(this).html());
        allOptions.toggle();
    });

    $('#dmgcnd1').parent().append('<ul class="list-item" id="newdmgcnd1" name="dmgcnd1"></ul>');
    $('#dmgcnd1 option').each(function () {
        $('#newdmgcnd1').append('<li value="' + $(this).val() + '">' + $(this).text() + '</li>');
    });
    $('#dmgcnd1').remove();
    $('#newdmgcnd1').attr('id', 'dmgcnd1');
    $('#dmgcnd1 li').first().addClass('init');
    $("#dmgcnd1").on("click", ".init", function () {
        $(this).closest("#dmgcnd1").children('li:not(.init)').toggle();
    });

    var allOptions2 = $("#dmgcnd1").children('li:not(.init)');
    $("#dmgcnd1").on("click", "li:not(.init)", function () {
        allOptions2.removeClass('selected');
        $(this).addClass('selected');
        $("#dmgcnd1").children('.init').html($(this).html());
        $("#dmgcnd1_sel").val($(this).html());
        allOptions2.toggle();
    });

    $('#dmgcnd2').parent().append('<ul class="list-item" id="newdmgcnd2" name="dmgcnd2"></ul>');
    $('#dmgcnd2 option').each(function () {
        $('#newdmgcnd2').append('<li value="' + $(this).val() + '">' + $(this).text() + '</li>');
    });
    $('#dmgcnd2').remove();
    $('#newdmgcnd2').attr('id', 'dmgcnd2');
    $('#dmgcnd2 li').first().addClass('init');
    $("#dmgcnd2").on("click", ".init", function () {
        $(this).closest("#dmgcnd2").children('li:not(.init)').toggle();
    });

    var allOptions3 = $("#dmgcnd2").children('li:not(.init)');
    $("#dmgcnd2").on("click", "li:not(.init)", function () {
        allOptions3.removeClass('selected');
        $(this).addClass('selected');
        $("#dmgcnd2").children('.init').html($(this).html());
        $("#dmgcnd2_sel").val($(this).html());
        allOptions3.toggle();
    });

    $('#dmgcnd3').parent().append('<ul class="list-item" id="newdmgcnd3" name="dmgcnd3"></ul>');
    $('#dmgcnd3 option').each(function () {
        $('#newdmgcnd3').append('<li value="' + $(this).val() + '">' + $(this).text() + '</li>');
    });
    $('#dmgcnd3').remove();
    $('#newdmgcnd3').attr('id', 'dmgcnd3');
    $('#dmgcnd3 li').first().addClass('init');
    $("#dmgcnd3").on("click", ".init", function () {
        $(this).closest("#dmgcnd3").children('li:not(.init)').toggle();
    });

    var allOptions4 = $("#dmgcnd3").children('li:not(.init)');
    $("#dmgcnd3").on("click", "li:not(.init)", function () {
        allOptions4.removeClass('selected');
        $(this).addClass('selected');
        $("#dmgcnd3").children('.init').html($(this).html());
        $("#dmgcnd3_sel").val($(this).html());
        allOptions4.toggle();
    });

    $('#register-form').validate({
        rules: {
            boss_name: {
                required: true,
            },
            ascii_sel: {
                required: true,
            },
            intro_text: {
                required: true,
            },
            taunt_text: {
                required: true,
            },
            channel: {
                required: true,
            },
            api_key: {
                required: true,
            },
            presentation: {
                required: true,
            },
            death_message: {
                required: true,
            },
            unix_users: {
                required: true,
            },
            ssh_pass: {
                required: true,
            },
            flag_loc: {
                required: true,
            },
            flag_con: {
                required: true,
            },
            dmgcnd1_sel: {
                required: true,
            },
            dmgcnd2_sel: {
                required: true,
            },
            dmgcnd3_sel: {
                required: true,
            },
            argument_1: {
                required: true,
            },
            argument_2: {
                required: true,
            },
            argument_3: {
                required: true,
            },
            sattack: {
                required: true,
            },
            aattack: {
                required: true,
            },
            clue: {
                required: true,
            },
            dialog_1: {
                required: true,
            },
            dialog_2: {
                required: true,
            },
            dialog_3: {
                required: true,
            },
            wtime: {
                required: true,
            },
            rtime: {
                required: true,
            }
        },
        onfocusout: function (element) {
            $(element).valid();
        },
    });

    jQuery.extend(jQuery.validator.messages, {
        required: "",
        remote: "",
        email: "",
        url: "",
        date: "",
        dateISO: "",
        number: "",
        digits: "",
        creditcard: "",
        equalTo: ""
    });
})(jQuery);