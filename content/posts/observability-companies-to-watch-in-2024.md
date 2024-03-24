---
title: "Observability Companies to Watch in 2024"
date: 2024-03-23T15:44:22-04:00
draft: true
series: []
tags: []
---

Observability is often described as three pillars--- logs, metrics, and traces.
Many companies have been built around this idea, but others have risen to
challenge it.

Let's see what observability companies are up to in 2024.

<!--more-->

I've recently been tasked with a project to consolidate observability systems.
Without going into details, the primary goals were to decrease the burden of
context switching between systems and increase debugging velocity across teams.

This project involved researching and evaluating observability companies to find
one that provided the best value. About midway through this research I found
Oxide's [RFD 68: Partnership as Shared Values][oxide-rfd-68].

This RFD changed the way I was thinking about this research by categorizing a
company as either a partner or a vendor, using values to weigh whether you
should choose to work with a company. If you have time I recommend reading that
RFD to influence the way you think about researching and evaluating companies.

After researching and evaluating many observability companies, these are the
companies I believe are worth watching in 2024.

1. [Honeycomb](#honeycomb)
1. [Axiom](#axiom)
1. [Grafana Labs](#grafana-labs)
1. [VictoriaMetrics](#victoriametrics)
1. [ClickHouse](#clickhouse)
1. [SigNoz](#signoz)
1. [Datadog](#datadog)

## Honeycomb

[Honeycomb][honeycomb] may not need an introduction, as they are a beloved
company in the observability space. They are pioneering an [Observability
2.0][honeycomb-obs-2.0] mindset that abandons the traditional three pillars of
observability in favor of [arbitrarily-wide structured log
events][honeycomb-wide-events]. The high-level idea is that these wide events
contain the necessary context to quickly and effectively observe your system.
You can think of a wide event as a structured log that contains all the
necessary fields you'd want to query, all linked by one or more fields (e.g.,
trace ID).

### Things I Like

The way Honeycomb thinks about observability is refreshing, especially in a
market filled with companies that can't wait to charge you more for adding an
extra label on your telemetry data. Honeycomb's Observability 2.0 mindset using
structured log events gives you control and freedom over your telemetry data
with the ability to query it quickly. It might feel awkward to ditch the three
pillars of observability at first, but if you do Honeycomb will reward you by
helping you find those pesky unknown unknowns within your system.

Honeycomb's [BubbleUp][honeycomb-bubbleup] feature is one of their key
differentiators and honestly it's a game-changer. BubbleUp takes the best
features from anomaly detection, correlation, and visualization and packages it
into an easy-to-use tool that anyone can use to identify outliers in telemetry
data. Check out Honeycomb's [sandbox][honeycomb-sandbox] for a demo of BubbleUp.

<!-- Talk about leadership. -->
<!-- Talk about support for OpenTelemetry. -->

<!-- Honeycomb's features are targeted at engineers that create or operate production -->
<!-- systems. Those that have the ability to either change how software emits -->
<!-- telemetry data or decorate emitted telemetry data before shipping it to a -->
<!-- destination. Honeycomb's focus on structured events can make it difficult for -->
<!-- teams to migrate from an Observability 1.0 mindset to Observability 2.0, -->
<!-- especially if those teams treat logs, metrics, and traces separately. However, -->
<!-- if you're writing a new application or willing to put in the time and effort to -->
<!-- transform your existing applications, Honeycomb will reward you by helping you -->
<!-- find those pesky unknown unknowns within your system. -->

### Things to Improve

<!-- Talk about difficult going from 1.0 to 2.0. -->
<!-- Talk about pricing making that difficult. -->

<!-- I've listed Honeycomb first on this list because I believe their way of thinking -->
<!-- about observability is where the industry is headed. Honeycomb is also a huge -->
<!-- advocate of [OpenTelemetry][opentelemetry], a popular collection of APIs and -->
<!-- SDKs for telemetry data. Led by industry leaders such as [Charity -->
<!-- Majors][linkedin-charity] and [Liz Fong-Jones][linkedin-liz], Honeycomb is well -->
<!-- positioned redefine observability for the masses. Be sure to check our their -->
<!-- [sandbox][honeycomb-sandbox] and join their [community][honeycomb-community]. -->

### Partner or Vendor?

## Axiom

[Axiom][axiom] is a newer company on this list. They started with the goal of
disrupting industry logging leader Splunk and have delivered an excellent
logging offering to do just that. Axiom's logging offering has expanded into
traces, with metrics support coming soon. Their "Stop sampling, observe every
event." tagline tells a story similar to Honeycomb's Observability 2.0 mindset
using structured log events.

### Things I Like

Axiom's text-based [Axiom Processing Language (APL)][axiom-apl], inspired by
Microsoft's [Kusto Query Language (KQL)][microsoft-kusto], is a powerful,
readable, and intuitive query language. The syntax uses pipes to separate
operators which should feel familiar to those used to Unix tools.

Here's an example APL query that extracts the job state from logs using regular
expressions, filters by successful jobs, and produces a summary of successful
jobs over time.

```apl
['app-logs']
| where message contains "transitioned to state"
| extend job_state = extract("transitioned to state (\\w+)", 1, message)
| where job_state == "succeeded"
| summarize num_jobs = count() by bin_auto(_time)
```

Readable, isn't it?

Outside of APL, I like that Axiom is thinking about observability similar to
Honeycomb with a focus on structured logs events. Axiom may have started with
the three pillars of observability, but it seems they are pivoting to structured
logs events, and can be a great competitor if they can execute well. 

Axiom's pricing model is based on ingest, measured in GiB/month. I like this
pricing model because it's predictable and meets companies where they are in
their observability journey. Companies can migrate from high volume, narrow
structured log events to lower volume, wide structued log events without
worrying about increasing their bill.

### Things to Improve

Axiom is a newer company, so the obvious thing they can do to improve is expand
their customer base and secure a spot in the market. Onboarding more customers
will build trust in their brand, test the reliability and scalability of their
platform, and expose new use cases that can be used to refine their roadmap.

More concretely, I would like to see Axiom land a first-class metrics experience
and expand their philosophy around structured log events. Metrics are listed as
coming soon on Axiom's website, but the platform does support ingesting metrics
via their [ingest API][axiom-ingest-api], with an OpenTelemetry Protocol (OTLP)
endpoint also listed as coming soon. If you do ingest metrics today, note that the metrics query experience isn't yet
up to par with competitors, lacking the ability to query histograms and
calculate rates for metric values over time.

### Partner or Vendor?

I view Axiom as more of a partner than a vendor. Their values align with my own,
they support open tooling such as OpenTelemetry, and their
[Discord][axiom-community] is active and growing. I've spoken with some of the
employees at Axiom and they were a joy to work with.

## Grafana Labs

[Grafana Labs][grafana].

### Things I Like

<!-- Self-hosting. -->
<!-- Powerful visualizations. -->

### Things to Improve

<!-- Pricing. -->
<!-- Different query languages. Products feel separate. -->

### Partner or Vendor?

<!-- In the middle honestly. -->

## VictoriaMetrics

[VictoriaMetrics][victoriametrics].

### Things I Like

<!-- Self-hosting. -->
<!-- Built their own time-series DB. -->
<!-- Powerful query language and PromQL compatibility. -->

### Things to Improve

<!-- Need a logging offering. -->
<!-- Focused on monitoring. -->

### Partner or Vendor?

<!-- Unsure, feels more like a vendor. -->

## ClickHouse

[ClickHouse][clickhouse].

### Things I Like

<!-- Extremely fast querying for large data. -->
<!-- Query language is SQL. -->

### Things to Improve

<!-- Not trying to be an observability tool. More OLAP. Not much to improve here honestly. -->

### Partner or Vendor?

<!-- Vendor. -->

## SigNoz

[SigNoz][signoz].

<!-- portmanteau name -->

### Things I Like

<!-- Built on ClickHouse. -->
<!-- Support for OpenTelemetry. -->

### Things to Improve

<!-- Feels three pillars ish. -->
<!-- Not well-known yet. -->

### Partner or Vendor?

<!-- Vendor. -->

## Datadog

[Datadog][datadog].

### Things I Like

<!-- Many features for many teams. -->
<!-- Proven. -->

### Things to Improve

<!-- Lock-in. -->
<!-- Pricing. -->

### Partner or Vendor?

<!-- Vendor. -->

[axiom-apl]: https://axiom.co/docs/apl/introduction "Axiom Processing Language"
[axiom-community]: https://axiom.co/support "Axiom community"
[axiom-ingest-api]: https://axiom.co/docs/restapi/endpoints/ingestIntoDataset "Axiom Ingest API"
[axiom]: https://docs.honeycomb.io/troubleshoot/community/ "Axiom website"
[clickhouse]: https://clickhouse.com/ "ClickHouse website"
[datadog]: https://datadoghq.com "Datadog website"
[grafana]: https://grafana.com/ "Grafana website"
[honeycomb-bubbleup]: https://www.honeycomb.io/bubbleup "Honeycomb BubbleUp"
[honeycomb-community]: https://docs.honeycomb.io/troubleshoot/community/ "Honeycomb community"
[honeycomb-obs-2.0]: https://www.honeycomb.io/blog/cost-crisis-observability-tooling "The Cost Crisis in Observability Tooling"
[honeycomb-sandbox]: https://www.honeycomb.io/sandbox "Honeycomb sandbox"
[honeycomb-wide-events]: https://www.honeycomb.io/blog/structured-events-basis-observability "Authors' Cut—Structured Events Are the Basis of Observability"
[honeycomb]: https://www.honeycomb.io/ "Honeycomb website"
[linkedin-charity]: https://www.linkedin.com/in/charity-majors/ "Charity Majors LinkedIn"
[linkedin-liz]: https://www.linkedin.com/in/efong "Liz Fong-Jones LinkedIn"
[microsoft-kusto]: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/ "Kusto Query Language"
[opentelemetry]: https://opentelemetry.io/ "OpenTelemetry website"
[oxide-rfd-68]: https://rfd.shared.oxide.computer/rfd/0068 "Partnership as Shared Values"
[signoz]: https://signoz.io "SigNoz website"
[victoriametrics]: https://victoriametrics.com/ "VictoriaMetrics website"
