# Platform Events v API Demo (Salesforce Side)
This app was built to explore the idea of loosely coupled event architectures that were not possible in Salesforce until Platform Events was a thing.

There are a lot of integration patterns in Salesforce that have tried to make up for the lack of a messaging queue on the platform: outbound messaging, callouts from apex, streaming api, polling from external services, and extremely well trained homing pigeons from Switzerland. However, each of these patterns lacks the simplicity and scalability of a message queue (esp. those dirty pigeons).

With events, developers can publish an event and walk away. If there are other systems that need to act on this action, they can subscribe to it and write whatever logic in whatever system they need to get their work done. This type of pattern is particularly useful when an application and separate systems that need to connect to it start to scale.

## Build the project
We used SFDX for development. We don't have instructions for anything else.
1. Clone this repo to your local computer `git clone https://github.com/pete-sfdc/CDGEventApp.git`
2. Spin up a scratch org `sfdx force:org:create -f project-scratch-def.json`
3. Deploy the zip in /mdapi `sfdx force:mdapi:deploy`
4. Push the source to your new scratch org `sfdx force:source:push`
5. Generate a password for the scratch org user `sfdx force:user:password:generate`
6. Grab username and password of user on scratch org `sfdx force:user:display`
7. Generate a security token for the default user (done through the Salesforce UI)
8. Create a connected app in Salesforce. Enable OAuth, callback url `http://localhost:3000/oauth/_callback`, ClientID = Consumer Key
9. Setup external service on Heroku. [The source and build instructions for the NodeJS side can be found here.](https://github.com/cowie/platformEventsNodeDemo)

## Resources
- [SFDX Trailhead](https://trailhead.salesforce.com/en/trails/sfdx_get_started)
- [Heroku tutorial for NodeJS](https://devcenter.heroku.com/articles/getting-started-with-nodejs#introduction)
- [Event Driven Architecture on Wikipedia](https://en.wikipedia.org/wiki/Event-driven_architecture)
- [Salesforce Platform Events Documentation](https://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/platform_events_intro_emp.htm)
- [Galactic Dust Driven Architecture](http://www.nyan.cat/)