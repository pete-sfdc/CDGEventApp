# Event Driven Architecture App
This app was built to explore the idea of loosely coupled event architectures that were not possible in Salesforce until Platform Events was a thing.

There are a lot of integration patterns in Salesforce that have tried to make up for the lack of a messaging queue on the platform: outbound messaging, callouts from apex, streaming api, polling from external services, and extremely well trained homing pigeons from Switzerland. However, each of these patterns lacks the simplicity and scalability of a message queue (esp. those dirty pigeons).

With events, developers can publish an event and walk away. If there are other systems that need to act on this action, they can subscribe to it, and write whatever logic in whatever system they need to get their work done, all the while, the first developer doesn't have to change anything about how they wrote their app. This is particularly useful when a system starts to scale.

## Build the project
We used SFDX for development. We don't have instructions for anything else.
 1. Clone this repo to your local computer `git clone https://github.com/pete-sfdc/CDGEventApp.git`
 2. Setup your project SFDX there, set up default hub auth if not already and default org
 3. Spin up a scratch org `sfdx force:org:create -f project-scratch-def.json`
 4. SFDX MDDeploy the zip in /mdapi `sfdx force:mdapi:deploy`
 5. SFDX source push to your org in org `sfdx force:source:push`
 6. Create new connected app and achieve oauth nirvana

The external service was built using NodeJS on top of Heroku.  [The source and build instructions for the NodeJS side can be found here.](https://github.com/cowie/platformEventsNodeDemo)

## Resources
- [SFDX Trailhead](https://trailhead.salesforce.com/en/trails/sfdx_get_started)
- [Heroku tutorial for NodeJS](https://devcenter.heroku.com/articles/getting-started-with-nodejs#introduction)
- [Event Driven Architecture on Wikipedia](https://en.wikipedia.org/wiki/Event-driven_architecture)
- [Salesforce Platform Events Documentation](https://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/platform_events_intro_emp.htm)
- [Galactic Dust Driven Architecture](http://www.nyan.cat/)