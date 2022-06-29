---
title_slug: nav.tenders
layout: default
permalink: /tenders/
redirect_from:
   - /Tender/
   - /Tender/index.html.de
   - /Tender/index.html.en
---

{% tf tenders/tenders.md %}

<button class="btn btn-sm rounded-pill bg-primary text-light" id="all">{% t tenders.filter.all %}</button>
<button class="btn btn-sm rounded-pill bg-secondary text-light" id="open">{% t tenders.filter.open %}</button>
<button class="btn btn-sm rounded-pill bg-secondary text-light" id="upcoming">{% t tenders.filter.upcoming %}</button> 
<button class="btn btn-sm rounded-pill bg-secondary text-light" id="closed">{% t tenders.filter.closed %}</button> 

<div class="table-responsive text-center">
<table>
  <thead>
    <th scope="col">#</th>
    <th scope="col">{% t tenders.name %}</th>
    <th scope="col">{% t tenders.description %}</th>
    <th scope="col">{% t tenders.start_date %}</th>
    <th scope="col">{% t tenders.closing_date %}</th>
    <th scope="col">{% t tenders.contracting_portal %}</th>
  </thead>
  <tbody>
    {% for lot in site.tenders %}
    <tr class="lot {{lot.state}}">
      <td>{%- if lot.retry -%}—{%- else -%}{{lot.number}}{%- endif -%}</td>
      <td>{% t lot.title_slug %}</td>
      <td>
        {%- capture content_length -%}{{lot.content | strip}}{%- endcapture -%}
        {%- if content_length == blank -%}
          Lot {{lot.number_vh81}}
        {%- else if -%}
          <a href="{{lot.url | prepend: site.baseurl}}">Lot {{lot.number_vh81}}</a>
        {%- endif -%}
      </td>
      <td>
        {%- if lot.start_date -%}
          {{lot.start_date}}
        {%- else if -%}
          <span class="fst-italic">tba</span>
        {%- endif -%}
      </td>
      <td>
        {%- if lot.closing_date -%}
          {{lot.closing_date}}
        {%- else if -%}
          <span class="fst-italic">tba</span>
        {%- endif -%}
      </td>
      <td>
        {%- if lot.state == "closed" -%}
          <span class="text-decoration-line-through">SCS-VP{{lot.number_vh81 | prepend: '00' | slice: -2, 2 }}{%- if lot.retry -%}-{{lot.retry}}{%- endif -%}</span>
        {%- elsif lot.contracting_portal -%}
          <a href="{{lot.contracting_portal}}">SCS-VP{{lot.number_vh81 | prepend: '00' | slice: -2, 2 }}{%- if lot.retry -%}-{{lot.retry}}{%- endif -%}</a>
        {%- else -%}
          <span class="fst-italic">tba</span>
        {%- endif -%}
      </td>
    </tr>
    {% endfor %}
  </tbody>
</table>
</div>

<script>
$(document).ready(function(){
  $(".btn").on("click", function() {
    $('.btn').addClass('bg-secondary').removeClass('bg-primary');
    $(this).removeClass('bg-secondary').addClass('bg-primary');
    if (this.id == "all") {
      $('.lot').show();
    } else {
      $('.lot').hide();
      $('.' + this.id).show();
    }
  });
});
</script>
