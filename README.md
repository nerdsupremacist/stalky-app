![Logo](https://github.com/mathiasquintero/stalky-app/blob/master/Icon.png)

# Stalky (App)
## Inspiration
It is estimated that an average person interacts with around 80.000 people during their lifetime (source: https://blog.adioma.com/counting-the-people-you-impact-infographic/) Even if you wanted to, there is no way for you to remember all of their names, let alone where you met them or what you learned about them during your encounter. The situation gets even trickier when you forget a name of someone you meet often, like a work colleague. **Stalky** can help with this!

## What it does
**Stalky** is an AR-enhanced contact book. It scans the person's face, performs face recognition using Microsoft Azure and based on it fetches different data about them using the Facebook API. It displays them on the phone in real time so that you never find yourself in the awkward situation of not recognising someone you already met.

### Ok? And how creepy is it?

Look for yourself:

![Screenshot](https://github.com/mathiasquintero/stalky-app/blob/master/gallery.jpg)

## How we built it
**Stalky** is an iOS app running on iOS 11 and utilising the power of Apple's new Vision Framework to extract faces from the camera feed. The faces are then sent to **Microsoft Azure** for processing and fetching additional information. Azure face recognition is trained using data from Facebook. Whenever a user logs in to Facebook using **Stalky**, our server fetches the list of all the user's friends who also use **Stalky**. These friends constitute the so called person group for that user. After that we fetch all the images for all the people in the person group, we extract exactly their faces based on Facebook tags and then we train Azure using those faces. Once training is done, the user can point their phone at any of the people in their person group and Azure will report who that is, providing different additional information. 

## Challenges we ran into
We decided to use Facebook API as it is mostly a to-go Social Media Platform. However it turned out that getting access to required data is restricted and it will only be able to recognise the people who use the Stalky app. 

## Accomplishments that we're proud of
We're really proud that we have a working system which can solve a _real life_ problem that many people face even on a daily basis. We are also proud we managed to tackle all the issues Facebook's API threw our way.

## What we learned
We learned how to do face recognition using **Microsoft Azure**. We also learned a bit about the magic of Apple's CoreGraphics framework.

## What's next for Stalky
The next big step towards turning **Stalky** into a production app is deploying it on devices that more seamlessly integrate into the use case of recognising people in daily life, such as **Microsoft HoloLens** or **Google Glass**. Additionally we plan to integrate a speech recognition feature which will be detecting names of people that you meet for the first time and saving those for later reference.

## Demo videos
https://www.youtube.com/watch?v=qS84dwYz32U
