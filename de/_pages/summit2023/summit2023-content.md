<!-- HEAD -->
{% asset lightslider/css/lightslider.css %}
{% asset lightslider/js/lightslider.min.js %}
<!-- /HEAD -->

<script type="text/javascript">
$(document).ready(function() {
    $("#lightSlider").lightSlider({
        item: 6,
        slideMargin: 20,
 
        auto: true,
        loop: true,
        pauseOnHover: true,
        slideEndAnimation: true,

        pager: true,
        currentPagerPosition: 'middle',
        controls: false,
 
        responsive : [
            {
                breakpoint:1400,
                settings: {
                    item:5,
                }
            },
            {
                breakpoint:1200,
                settings: {
                    item:4,
                }
            },
            {
                breakpoint:992,
                settings: {
                    item:3,
                }
            },
            {
                breakpoint:768,
                settings: {
                    item:2,
                }
            }
        ],
    });
});
</script>

<link rel="stylesheet" type="text/css" href="https://pretix.eu/SovereignCloudStack/hackathon-2022/widget/v1.css">
<script type="text/javascript" src="https://pretix.eu/widget/v1.en.js" async></script>
<style>
.pretix-widget button {
  border-color: #50c3a5;
  background-color: #50c3a5;
}
.pretix-widget a {
  color: #50c3a5;
}
.pretix-widget input[type="checkbox"] {
  accent-color: #50c3a5;
}
</style>

<figure class="figure mx-auto d-block" style="width:100%">
    {% asset 'summit2023/banner.png' class="figure-img w-100" %}
</figure>

{% tf summit2023.md %}
