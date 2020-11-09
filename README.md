# Prince Charming - Open Telemetry / GCP Demo App

"Ridicule is nothing to be scared of" - Adam Ant 'Prince Charming'

This is a demonstration of using [Open Telemetry](https://opentelemetry.io/)
to instrument a [Google Cloud Functions](https://cloud.google.com/functions)
app.

# Why?

One of the hardest things I find about starting on a new project, in a new domain
and/or with a new technology is gaining situational awareness.

Figuring out what is going on and where I am in relation to it.

Whenever I start on something I like to use John Boyd's OODA loop as a mantra

Observe
Orientate
Decide../services/api/app/utils/frameio/aqc_comments.py
Act

Dan North has a similar one I find useful

Visualise
Stableise
Optimise 

I had a go at drawing some sequence diagrams but these got out of date
whenever the architecture changed.

As the architecture was a set of loosely coupled Cloud Functions this
happened a lot.

# What?

Get the system to describe itself. Show how it is composed and what it does
rather than telling people what I think it does. 

# How?

Correlation IDs

This is an idea I was introduced to by Matthew Skelton and Rob Thatcher

Which brings us to

Jaeger and Open Telemetry

This all got a bit meta as I discovered that Open Telemetry was very much
an emerging technology.

One of the problems with getting started with a new project and a
new technology is your questions are inevitably naive.  This can end up 
soliciting derision from the people you ask and in turn make
you reluctant to ask questions.

We often talk about 'Safe to Fail' envionments.
Emily Webber takes this a step further and talks about them being 'Safe to Learn'

# So why Prince Charming?

As Adam Ant put it 'ridicule is nothing to be scared of' If people mock you
for your lack of knowledge rather than help you learn that is not your loss.

Don't let it stop you from learning.

## Kismit.

Lisa Crispin on the Open Telemetry Glitter
When I searched for Emily Webber "Safe to Learn" I got a Lisa Crispin blog entry

"You know that's not how you're supposed to do that"
