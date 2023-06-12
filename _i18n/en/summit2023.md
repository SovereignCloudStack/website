# Sovereign Cloud Stack Summit 2023

Dear Friends of SCS and interested Observers,

The Sovereign Cloud Stack is now in its second year successfully building a community to develop and maintain a standardized open source cloud computing stack. Success means that we have released the fourth version and that by now four public cloud service providers base their offering on SCS standards and technology. Reason enough to call for our first summit, which happened on **23rd and 24th of May 2023 in Berlin** for users, developers, adopters and everybody, who is affiliated to this project to gather, share knowledge, as well as experience and to – of course – network and have fun.

## Thank you!

The event is now over. We had really interesting presentations and panel discussions on stage and really good conversations with all participants. Thanks for everyone who joined us, but especially the speakers and organizers!

This page will remain in place, documenting the event and containing links to the slides and videos from the program.

## Speakers

{% include summit2023/speakers.html %}

## Schedule

<div class="container my-4">
    <!-- Nav tabs -->
    <ul class="schedule-nav nav nav-pills nav-justified" id="schedule-tab" role="tablist">
        <li class="nav-item me-2">
            <a class="nav-link active" id="tab-day-1" data-bs-toggle="tab" href="#day-1" role="tab"
                aria-controls="day-1" aria-selected="true">
                <span class="heading">Day 1</span>
                <span class="meta d-none d-lg-block">(Tuesday, May 23)</span>
            </a>
        </li>
        <li class="nav-item me-2">
            <a class="nav-link" id="tab-day-2" data-bs-toggle="tab" href="#day-2" role="tab" aria-controls="day-2"
                aria-selected="false">
                <span class="heading">Day 2</span>
                <span class="meta d-none d-lg-block">(Wednesday, May 24)</span>
            </a>
        </li>
    </ul>
    <!-- Tab panes -->
    <div class="schedule-tab-content tab-content mt-5">
        {% for i in (1..2) %}
        <div class="tab-pane fade {% if i == 1 %}show active{% endif %}" id="day-{{i}}" role="tabpanel"
            aria-labelledby="day-{{i}}">
            {% for talk in site.data.summit2023-talks %}
            {% if i == talk.day %}
            <div class="item item-talk">
                <div class="meta">
                    <h4 class="time">{{talk.start}} – {{talk.end}}</h4>
                    <div class="profile mt-3">
                        <div class="d-flex justify-content-center">{% assign post = talk %}{% include news/blog_avatars.html %}</div>
                        <div class="name mt-2">
                        {{talk.speaker | join: ", "}}
                        </div>
                    </div>
                    <!--//profile-->
                </div>
                <!--//meta-->
                <div class="content">
		    {% if talk.title_en %}
                    <h3 class="title mb-2">{{talk.title_en}}<a data-tab-destination="day-{{i}}"
                            href="#session-{{ forloop.index }}" class="link-unstyled">
		    {% else %}
                    <h3 class="title mb-2">{{talk.title}}<a data-tab-destination="day-{{i}}"
                            href="#session-{{ forloop.index }}" class="link-unstyled">
                    {% endif %}
			<i class="fa fa-link ms-2 text-muted" aria-hidden="true" style="font-size: .7em;"></i></a>
                    </h3>
                    <div class="location mb-2 text-muted"><i class="fa fa-map-marker me-2"
                            aria-hidden="true"></i>{{talk.location}}</div>
                    {% if talk.description_en %}
                    <div class="desc pb-2">{{talk.description_en}}</div>
		    {% else %}
                    <div class="desc pb-2">{{talk.description}}</div>
                    {% endif %}
                    {% if talk.slides %}
			<div class="desc pb-2"><a href="{{talk.slides}}">Slides</a></div>
		    {% endif %}
                    {% if talk.video %}
			<div class="desc pb-2"><a href="{{talk.video}}">Video</a></div>
		    {% endif %}
		</div>
                <!--//content-->
            </div>
            {% endif %}
            {% endfor %}
        </div>
        {% endfor %}
    </div>
</div>

## Location

The SCS Summit took place in the beautiful facilities of the Berlin-Brandenburg Academy of Sciences and Humanities (BBAW). You can find [detailed directions on the official BBAW website](https://veranstaltungszentrum.bbaw.de/en/directions).

{% include summit2023/bbaw.html %}

## Sponsors

{% include summit2023/sponsors.html %}

## Contact us

If you need any further information, please contact [Bianca](https://scs.community/hollery) or [Alexander](https://scs.community/diab) – they’ll be happy to help you. See you in Berlin!

{% include summit2023/contact.html %}
