+++
title       = "Observability Companies to Watch in 2024"
description = "Observability companies worth watching in 2024."
summary     = "Observability companies worth watching in 2024."
keywords    = []
date        = "2024-03-31T21:00:00-04:00"
publishDate = "2024-03-31T21:00:00-04:00"
lastmod     = "2024-03-31T21:00:00-04:00"
draft       = false
aliases     = []
featureAlt  = "A telemetry line graph showing the number of traces for an application."

# Taxonomies.
categories = []
tags       = []
+++

Observability is often described as three pillars---logs, metrics, and traces.
Many companies have been built around this idea, but others have risen to
challenge it.

Let's see what observability companies are up to in 2024.

I've recently been tasked with a project to consolidate observability systems.
The primary goals were to decrease context switching between systems and
increase debugging velocity across teams.

This project involved researching and evaluating observability companies to
find one that provided the best value. About halfway through this research I
found Oxide's [RFD 68: Partnership as Shared Values][oxide-rfd-68].

This RFD changed the way I was thinking about this research by categorizing a
company as either a partner or a vendor, using values to weigh whether you
should choose to work with a company. I recommend reading that RFD if you have
the time.

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
market filled with companies looking to charge you more for adding an extra
label on your telemetry data. Honeycomb's Observability 2.0 mindset using
structured log events gives you control and freedom over your telemetry data
with the ability to query it quickly. It might feel awkward to ditch the three
pillars of observability, but when you do Honeycomb will reward you by helping
you find those pesky unknown unknowns within your system.

Honeycomb's [BubbleUp][honeycomb-bubbleup] feature is one of their key
differentiators and it's a game-changer. BubbleUp takes the best features from
anomaly detection, correlation, and visualization, packaging them into an
easy-to-use tool that anyone can use to identify outliers in telemetry data.
Check out Honeycomb's [sandbox][honeycomb-sandbox] for a demo of BubbleUp.

Honeycomb is a huge advocate for [OpenTelemetry][opentelemetry], a popular open
source collection of APIs and SDKs for telemetry data, with first-class support
for the OpenTelemetry Protocol (OTLP) in their APIs and libraries. The
leadership at Honeycomb includes industry leaders [Charity
Majors][linkedin-charity] and [Liz Fong-Jones][linkedin-liz], both of which
have extensive observability experience and share a common vision. With both
the technical and non-technical sides covered, Honeycomb is well positioned to
take their Observability 2.0 mindset mainstream.

### Things to Improve

Honeycomb is targeted at teams that create or operate production systems,
primarily those that have the ability to either change how software emits
telemetry data or decorate emitted telemetry data before shipping it to a
destination. Honeycomb's focus on structured log events can make it difficult
for teams to migrate from an Observability 1.0 mindset to Observability 2.0,
especially if those teams treat logs, metrics, and traces separately. I would
like to see Honeycomb bridge the gap between Observability 1.0 and
Observability 2.0.

Honeycomb's pricing is based on events, measured in events/month. This pricing
model is great because it doesn't penalize teams for sending high-cardinality
telemetry data. However, this pricing model can become expensive for teams with
separate logs, metrics, and traces looking to migrate to Honeycomb. Instead of
being able to send their data as-is and incrementally migrate towards an
Observability 2.0 approach, teams must choose to either sample data or dedicate
resources to creating structured log events. I believe Honeycomb has a great
opportunity here to enhance this experience and better support teams in this
scenario.

### Partner or Vendor?

I view Honeycomb as a partner. I believe their Observability 2.0 vision is
where the industry is headed and they are willing to partner with companies to
transform their way of thinking about observability. Honeycomb is one of the
biggest advocates for OpenTelemetry and their [Pollinators
Slack][honeycomb-community] is buzzing with people that have tasted the
sweetness of Observability 2.0. I had the opportunity to chat with a few
employees from Honeycomb, provide feedback on their product, and test changes
that they made based on the feedback. Honeycomb isn't selling you a product.
They are selling a vision of what observability can look like with a tool to
turn that vision into reality.

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
Honeycomb with a focus on structured log events. Axiom may have started with
the three pillars of observability, but it seems they are pivoting to
structured log events, and can be a great competitor if they can execute well.

Axiom's pricing model is based on ingest, measured in GiB/month. I like this
pricing model because it's predictable and meets companies where they are in
their observability journey. Companies can migrate from high volume, narrow
structured log events to lower volume, wide structured log events without
worrying about increasing their bill.

### Things to Improve

Axiom is a newer company, so the obvious thing they can do to improve is expand
their customer base and secure a spot in the market. Onboarding more customers
will build trust in their brand, test the reliability and scalability of their
platform, and expose new use cases that can be used to refine their roadmap.

More concretely, I would like to see Axiom land a first-class metrics
experience and expand their philosophy around structured log events. Metrics
are listed as coming soon on Axiom's website, but the platform does support
ingesting metrics via their [ingest API][axiom-ingest-api], with an
OpenTelemetry Protocol (OTLP) endpoint also listed as coming soon. If you do
ingest metrics today, note that the metrics query experience isn't yet up to
par with competitors, lacking the ability to query histograms and calculate
rates for metric values over time.

### Partner or Vendor?

I view Axiom as more of a partner than a vendor. Their values align with my
own, they support open tooling such as OpenTelemetry, and their
[Discord][axiom-community] is active and growing. I've spoken with some of the
employees at Axiom and they were a joy to work with. They were the only vendor
that didn't hesitate to enable the enterprise trial and they expressed interest
in receiving feedback to better their product. Given their smaller size, the
overall experience felt personable.

## Grafana Labs

[Grafana Labs][grafana-labs] is the company behind the popular
[Grafana][grafana-labs-grafana] visualization tool. Grafana Labs has since
expanded their offerings into Loki, Mimir, and Tempo for logs, metrics, and
traces respectively. Their entire range of offerings is marketed as the "LGTM"
stack, which stands for Loki, Grafana, Tempo, and Mimir, and plays on the
familiar "looks good to me" message teams use in code reviews.

### Things I Like

Grafana Labs has an open source tier of their offerings that can be
self-hosted. In fact, I'd argue that's what made Grafana Labs popular in the
industry. Teams that use Grafana Labs' offerings in production often ship the
open source versions alongside their applications in non-production
environments to give teams the same observability experience across production
and non-production. That's a stark difference compared to other SaaS companies
where it's cost prohibitive to send telemetry data from non-production
environments and teams must either do without their telemetry data or find
another way to visualize and query it.

Grafana itself is a powerful visualization tool. If you haven't used Grafana
yet I encourage you to try it. Grafana can read telemetry data from many
different data sources, including the popular metrics tool Prometheus, and
visualize that telemetry data using the query language of the data source
itself. That means you can visualize [Prometheus][prometheus] metrics using its
own PromQL syntax and Elasticsearch data using its lucene syntax. This is not
to say other offerings like Loki and Tempo aren't good, but Grafana is the
standard when it comes to visualization, so much so that other companies often
bundle Grafana with their own offerings.

### Things to Improve

Grafana Labs has a SaaS offering called Grafana Cloud that you can use if you
don't want to self host. However, I found the pricing of Grafana Cloud to be
expensive when compared with other companies, especially at scale. I would like
to see Grafana Cloud become more competitive with their pricing over time.

As noted above, Grafana allows you to visualize telemetry data backed by the
query language of the data source itself. This is a benefit when teams are
familiar with a given query language and mostly use a few data sources, but can
quickly become a burden when context switching between data sources. On top of
that, Grafana Labs' own offerings use slightly different query languages (e.g.,
PromQL for Mimir, LogQL for Loki, TraceQL for Tempo) which can burden teams
with unnecessary context switching.

### Partner or Vendor?

Overall I struggled to answer this question for Grafana Labs. On one hand they
feel like a partner when you look at their open source offerings coupled with
their sponsorship of open source projects. On the other hand their Grafana
Cloud offering feels like a vended product that attempts to unify logs,
metrics, and traces telemetry data through their Grafana visualization
interface. The people I spoke to at Grafana were easy to work with but I didn't
end up doing a serious evaluation of their Grafana Cloud offering due to
pricing concerns.

## VictoriaMetrics

[VictoriaMetrics][victoriametrics] is the company that created the
VictoriaMetrics time series database as a more reliable, memory efficient
replacement for existing time series databases. They have since expanded into
logs with their VictoriaLogs offering, which at the time of this writing is in
preview.

### Things I Like

VictoriaMetrics is open source and popular with those looking for an efficient
self-hosted metrics solution. Speaking of self hosting, getting set up with
VictoriaMetrics is quick and intuitive, so be sure to download its all-in-one
binary or container image and check it out. I also like that VictoriaMetrics
wrote their own time series database after researching the pain points
operators were experiencing with other metrics offerings. VictoriaMetrics also
has a SaaS offering if you don't want to self host.

VictoriaMetrics supports a wide range of ingestion protocols including
Prometheus, Graphite, OpenTSDB, CSV, and InfluxDB. This wide range of support
makes it easier for teams to migrate their workloads to VictoriaMetrics.
Generally speaking, VictoriaMetrics is a drop-in replacement for any one of the
previously mentioned tools.

### Things to Improve

I'd like to see VictoriaMetrics continue to expand into other telemetry data.
This is already in development with their VictoriaLogs offering, but I think
going the full distance with traces would be beneficial. Right now
VictoriaMetrics seems more like a monitoring company than an observability
company, but perhaps that will change with time.

Another thing I would like to see changed is for VictoriaMetrics to list
pricing information on their website. Currently, you must request pricing
information by filling out a form and waiting to be contacted. Trust me, I get
it. When you're a smaller company you want to make sure leads are fruitful and
have a good chance of converting into a sale. However, it's difficult for teams
to estimate pricing for growth without posting it on the website.

### Partner or Vendor?

I don't believe I have enough information to answer this question accurately.
VictoriaMetrics is one of those companies I'm keeping my eye on and might
migrate a few Prometheus workloads over to in due time. If I had to answer this
question I would say VictoriaMetrics feels more like a vendor than a partner
since their primary product is meant to target existing products rather than
carve a new path of its own. I didn't join the VictoriaMetrics Slack to see how
their community building is, nor did I speak to any employees from the company
to make me lean towards partner here.

## ClickHouse

[ClickHouse][clickhouse] isn't exactly an observability company. They are an
open source database for online analytical processing (OLAP) workloads. Their
claim to fame is that they are fast and efficient. No really, they are
[_fast_][clickhouse-fast]. They are on this list because their speed and
efficiency make their database attractive for storing telemetry data and
companies are starting to pop up that use ClickHouse as their storage and
querying layer.

### Things I Like

ClickHouse has a clear vision and knows exactly what they're offering. They are
focused on ensuring their database remains fast and reliable as you store
billions of rows of data inside. I like their dedication to their vision and
their astonishing performance. Try loading up a large data set and querying it
to see what I mean.

Like most databases, ClickHouse uses SQL as its query language. Teams that are
familiar with SQL will feel right at home when querying data and companies
looking to use ClickHouse as their storage layer will have stable APIs to build
from. I'm not saying that SQL is the _best_ query language, but it's ubiquity
makes it simple to use ClickHouse.

### Things to Improve

I don't have anything specific to say here. It wasn't exactly fair for me to
include ClickHouse on this list since they are focused on OLAP workloads.
Instead, I'll give them a pass and thank them for the work they are doing.

### Partner or Vendor?

Definitely vendor. I don't say that in a bad way either. I say it because
ClickHouse knows the target audience for their database and is marketing to
that audience well. For the average operator, I imagine purchasing ClickHouse
would be mostly transactional in that you'll buy the database and use it in
your workflows, only reaching out to ClickHouse when there are issues or
feature requests.

## SigNoz

[SigNoz][signoz] is an observability company whose mission is to help you find
the signal in the noise. If you couldn't tell, their name is a portmanteau on
the words signal and noise. SigNoz takes all of the open source observability
tooling you know and love and glues them together through their visualization
tooling.

### Things I Like

I have not personally used SigNoz, but I've placed them on this list because
they are one of those companies that are using ClickHouse to store and query
telemetry data and I wanted to keep an eye on their progress. In addition to
using ClickHouse, SigNoz leans into OpenTelemetry much like Honeycomb, using it
as their ingest layer. Take a look at their [architecture][signoz-architecture]
to understand how all these components fit together.

### Things to Improve

From their demo video, SigNoz reminds me of Grafana Labs. They treat logs,
metrics, and traces separately and unite them with their visualization
experience. In this sense it may feel like SigNoz has not yet found its own
identity, but we'll have to wait and see. That brings me to the point I was
trying to make--- SigNoz is not yet well-known or proven. I'd like to see them
become more utilized over time and their name one that is frequently brought up
in observability conversations.

### Partner or Vendor?

I can't answer this one given that I didn't use their product. I'll be keeping
an eye on SigNoz to see how their decision to use OpenTelemetry and ClickHouse
pans out.

## Datadog

[Datadog][datadog] is one of the first companies people think of when talking
about observability. They have been around for a while and are the default
observability choice for many. Datadog started with metrics and expanded into
logs and traces over time, now offering a rich portfolio covering use cases
across infrastructure, security, and application development. I put Datadog on
this list since they are the current industry leader and I want to watch how
they react with increased competition.

### Things I Like

No matter your use case Datadog likely has an offering for you. This is
attractive to teams that need a single company to meet the diverse needs across
teams. While Datadog may not be the best at any one thing, they are good enough
across everything and I like that about them.

Datadog is a proven company in the industry. Their wide customer base gives
companies confidence that Datadog will be around for years to come and that
they can scale to meet their use cases. Datadog is a safe choice for
observability and, as the saying goes, no one ever got fired for buying
Datadog.

### Things to Improve

Everything I said about Datadog sounds great on paper but it all comes at a
cost. Datadog's pricing is... complex to say the least. Go ahead and navigate
to their [pricing page][datadog-pricing] and click through the different
offerings in the sidebar. Let me know if you're able to accurately estimate
what your bill would look like if you migrated to Datadog. Seriously, ping me
if you were able to easily do this. Outside of being complex, Datadog's pricing
is expensive! Take a look at what they charge for custom metrics, which would
be any metric that is emitted from your in-house application. You know, the
applications your company runs to make money. There are many videos and blog
posts about Datadog's expensive pricing so I won't go into any more detail
here. Feel free to research this for yourself.

Outside of pricing, it's easy to become locked in to Datadog. Datadog has their
open source [Datadog agent][datadog-agent] that makes it simple to send them
telemetry data. The agent comes with many integrations that you can toggle with
a simple boolean in their configuration file. I dislike two things about the
agent. First, it's not clear if there are any billing implications when an
integration is enabled, which I won't dive into any further since I already
spent time talking about pricing. Second, the agent treats metrics coming from
integrations as standard metrics instead of custom metrics. Standard metrics
are far cheaper than custom metrics so if you choose to emit metrics from an
application directly instead of using their integration, you'll pay more for
the same exact metrics.

Standard metrics may also be transformed by the agent into a "canonical" format
that's specified by Datadog. For example, say you have a `foo` application that
emits a Prometheus metric named `bar_http_requests`. You have queries using
this metric and you want to create a `foo` integration in the Datadog agent so
others can easily get your application's metrics into Datadog. Before accepting
your `foo` application as an integration, Datadog may choose to rename your
metric to `foo.bar.http_requests` which is not what your application emits in
the first place. Granted, adding the `foo.` prefix makes sense since it helps
prevent collisions between integrations but after that no further
transformations should be done. This behavior makes it extremely difficult to
migrate away from Datadog since it will require updates to your queries that
are using the original metric name.

### Partner or Vendor?

Datadog is definitely a vendor. They are focused on increasing their revenue
and building their walled garden, not on innovating in the observability space.
It's no secret that people are unhappy with Datadog's pricing, vendor lock-in,
and treatment of the OpenTelemetry community and are looking for a company to
supplant them.

[axiom-apl]: https://axiom.co/docs/apl/introduction "Axiom Processing Language"
[axiom-community]: https://axiom.co/support "Axiom community"
[axiom-ingest-api]: https://axiom.co/docs/restapi/endpoints/ingestIntoDataset "Axiom Ingest API"
[axiom]: https://axiom.co "Axiom website"
[clickhouse-fast]: https://clickhouse.com/docs/en/concepts/why-clickhouse-is-so-fast "Why is ClickHouse so fast?"
[clickhouse]: https://clickhouse.com/ "ClickHouse website"
[datadog-agent]: https://docs.datadoghq.com/agent/ "Datadog Agent"
[datadog-pricing]: https://www.datadoghq.com/pricing/ "Datadog pricing"
[datadog]: https://datadoghq.com "Datadog website"
[grafana-labs-grafana]: https://grafana.com/grafana/ "Grafana product"
[grafana-labs]: https://grafana.com/ "Grafana Labs website"
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
[prometheus]: https://prometheus.io/ "Prometheus website"
[signoz-architecture]: https://signoz.io/docs/architecture/ "SigNoz Technical Architecture"
[signoz]: https://signoz.io "SigNoz website"
[victoriametrics]: https://victoriametrics.com/ "VictoriaMetrics website"
