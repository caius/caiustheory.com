---
title: Stop HealthKit causing SIGABRT
date: 2016-10-15 09:15 UTC
tags:
  - iOS
  - swift
---

You have some crazy idea for an iOS app that uses HealthKit so you fire up Xcode, create a new project & add the HealthKit entitlement. Follow the tutorial to request authorization from the `HKHealthKitStore`. Hit run to make sure the app compiles and find that it instantly crashes with a `SIGABRT` in `AppDelegate`.

Puzzled by this you go over the minimal amount of code you've added and pare it right down to just the `HKHealthKitStore.requestAuthorization` call which is still causing the `SIGABRT` as soon as the app tries to boot.

The missing piece of the puzzle is `Info.plist` needs a key adding to it for the HealthKit authorisation screen. The documentation helpfully forgets to mention this however. Here's some quick simple steps to fix it:

1. Open `Info.plist` in Xcode
2. Click the `(+)` at the top to add a new key/value to the file
3. Enter "Privacy - Health Share Usage Description" for the key
4. Enter a useful message to the user explaining why they should allow access to their healthkit data for your app for the value
5. Run your app and see the HealthKit authorisation sheet appear

**NB**: if you want to update/write any data to healthkit, you'll need to add the "Privacy - Health Update Usage Description" key with a description as well.
