# Duke Event Calendar
- For Duke students to be better engaged with campus events and connect with each other.

- By Yu Wu(yw541@duke.edu), Xincheng Zhong(xz353@duke.edu), Aoli Zhou(az161@duke.edu)
-  Task Breakdown: 
https://docs.google.com/spreadsheets/d/1I9JvUu8_3zd9J_S5GnvwtkzJzSwUi4LVppxqawC8gDc/edit?usp=sharing

# Key Features
## Fetch & filter campus events 
- Pull-down to refresh
- Press right-top button to filter the events by category / sponsor(group) / time.
 
![alt text](https://gitlab.oit.duke.edu/kits/ECE-564-01-F23/projects/new-bee/-/raw/main/ReadmeImg/refresh.png?ref_type=heads){width=250}
- On filter page, category could be saved.
- Remove the filter tag by long-pressing it and press the cross

![alt text](https://gitlab.oit.duke.edu/kits/ECE-564-01-F23/projects/new-bee/-/raw/main/ReadmeImg/filterpage.jpeg?ref_type=heads){width=250}

## Event details
- Check detailed information, some with registration page or map page if the API provides these information
- Add any event to iphone calendar
- Set any event as interested or cancel it

![alt text](https://gitlab.oit.duke.edu/kits/ECE-564-01-F23/projects/new-bee/-/raw/main/ReadmeImg/detailpage.png?ref_type=heads){width=250}
![alt text](https://gitlab.oit.duke.edu/kits/ECE-564-01-F23/projects/new-bee/-/raw/main/ReadmeImg/pastevents.png?ref_type=heads){width=250}
- Enter any sponsor(group) page and follow / unfollow it

![alt text](https://gitlab.oit.duke.edu/kits/ECE-564-01-F23/projects/new-bee/-/raw/main/ReadmeImg/groupp.png?ref_type=heads){width=200}

## Comment
- Comment below any event
- Delete a comment made by yourself, or reply to others

![alt text](https://gitlab.oit.duke.edu/kits/ECE-564-01-F23/projects/new-bee/-/raw/main/ReadmeImg/%20comment.png?ref_type=heads){width=250}

## Notifications
- Messages from developer team
- Events start notification: 30 minites before a event set as interested start

![alt text](https://gitlab.oit.duke.edu/kits/ECE-564-01-F23/projects/new-bee/-/raw/main/ReadmeImg/noti.png?ref_type=heads){width=250}
![alt text](https://gitlab.oit.duke.edu/kits/ECE-564-01-F23/projects/new-bee/-/raw/main/ReadmeImg/noti_on_lock.png?ref_type=heads){width=250}
![alt text](https://gitlab.oit.duke.edu/kits/ECE-564-01-F23/projects/new-bee/-/raw/main/ReadmeImg/noti_on_interested.png?ref_type=heads){width=250}
![alt text](){width=250}


# Setup
- Upgrade your running system above iOS 17.
- Clone this Git repo to your laptop, open the DukeEventCalendar.xcodeproj file in Xcode and run it
- Open the app and allow the notification
**Feel free to contact the developer team if you encounter any problem**

# Login Info
For testing convenience, no password is needed, you may type in any username as you want. The server will generate the account automatically if the username has not been registered. 

![alt text](https://gitlab.oit.duke.edu/kits/ECE-564-01-F23/projects/new-bee/-/raw/main/ReadmeImg/loginpage.jpeg?ref_type=heads){width=250}
![alt text](https://gitlab.oit.duke.edu/kits/ECE-564-01-F23/projects/new-bee/-/raw/main/ReadmeImg/profilepage.png?ref_type=heads){width=250}

# Backend Server
- Powerful and Robust vapor server completed by Yu Wu (yw541@duke.edu)
- Server code and its README: https://gitlab.oit.duke.edu/yw541/ece564project_server
