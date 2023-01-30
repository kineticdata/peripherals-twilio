# Twilio_SMS_Message_Send_From_V2
Interacts with Twilio to send a string to a mobile device.

## Parameters
[From]
  Phone number that the message will be sent from in the format of 
  +[country code][phone number]
  (this is one of your registered Twilio numbers)

[To]
  Phone number that the message will be sent to in the format of 
  +[country code][phone number]

[Message]
  Message to send

### Sample Configuration
From:                +16121231212

To:                  +16515551212

Message:             Your request KSR111 has been approved.

## Results
This handler returns no results


## Detailed Description
This handler interacts with Twilio to send a text message to a phone
number of your choosing. This handler uses the 
Account SID and Auth Token (both can be found on the twilio account dashboard) 
to authenticate the sending of the message. The number that you are sending the
message to must be of the form "+[country code][phone number]" with no spaces. 
The message limit is defined by Twilio.

