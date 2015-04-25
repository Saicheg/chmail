 var $bgColor = "#ffffff";
        var $fontColor = "#000000";
        $(function($){
            $('#colorSelector').ColorPicker({
                color: '#ffffff',
                onShow: function (colpkr) {
                    $(colpkr).fadeIn(500);
                    return false;
                },
                onHide: function (colpkr) {
                    $(colpkr).fadeOut(500);
                    return false;
                },
                onChange: function (hsb, hex, rgb) {
                    $('#colorSelector div').css('backgroundColor', '#' + hex);
                    $('#created_banner > div').css('backgroundColor', '#' + hex);
                    $bgColor = "#" + hex;
                }
            });
            $('#colorFontSelector').ColorPicker({
                color: '#000000',
                onShow: function (colpkr) {
                    $(colpkr).fadeIn(500);
                    return false;
                },
                onHide: function (colpkr) {
                    $(colpkr).fadeOut(500);
                    return false;
                },
                onChange: function (hsb, hex, rgb) {
                    $('#colorFontSelector div').css('backgroundColor', '#' + hex);
                    $('#created_banner').css('color', '#' + hex);
                    $fontColor = "#" + hex;
                }
            });
        });
        function submit () {
            createBanner();
            $('form').submit();
        }
        function uploadImage () {
            var src = $(event.target).val();
            $("#banner_image").attr("src", src)
        }
        function createBanner () {
            var name = $("[name=name]").val();
            var description = $("#description").val();
            var link_url = $("[name=app_url]").val();
            var template = $("<a>").attr("id","created_banner").attr("href",link_url).css(
            {
                "text-decoration": "none",
                "color": $fontColor
            })
            .append(
                $("<div>").css(
                {
                    "width":"320px",
                    "height":"50px",
                    "border":"solid 1px grey",
                    "background-color" : $bgColor
                })
                .append(
                    $("<p>").css({"width":"320px", "height" : "14px", "font-size": "12px", "padding":"3px 3px 0px 3px", "margin-bottom" : "0px", "margin-top": "0px"}).text(name),
                    $("<p>").css({"width":"320px", "height" : "24px", "font-size": "10px", "padding":"3px 0px 3px 3px", "margin-bottom" : "0px", "margin-top": "0px"}).text(description)
                    )
                );
            $("#banner_box").children().remove();
            $("#banner_box").append(template);

            $("#banner_input").val($("#banner_box").html());
        }