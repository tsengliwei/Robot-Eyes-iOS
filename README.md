# Robot-Eyes-iOS


There are three screens after login: Dashboard, Uploads and Account Views.

The logic of Account and login view controllers are straightforward


## Dashboard

# DashboardTableViewController

This table view controller contains Dashboardcell

We have four local arrays to store messages, usernames, imageFiles, drawViewFiles

refresh() fetch data from Parse.com and update dashboard views


# DashboardCell

We have postedImage, drawViewImage, username and message outlet.

Difference between postedImage and drawViewImage: postedImage is the original photo, while drawViewImage refers to the one users draw



## DrawView

# DrawView

This view contains Line

Implement the logic to draw lines on the view

# Line

Data structure for line



## UploadViewController

Three main sections:  IB (UI properties and methods), helpers, and control keyboard,

Notes: 
Since UIImage doesn't allow users to draw on it, we have a UIView layer which we can draw on top of UIImage. To 
upload to Parse, however, we convert UIView to UIImage.

Also, to make sure UIView always has the exact same size as UIImage, we resize every image to a fixed size
