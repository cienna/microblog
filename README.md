# github repo: https://github.com/cienna/microblog
# live site: http://microblog.ciennadubay.com

# test-restarted the server - the blog survived


# Visiting the blog gives you a signup page; you can log in on the navbar.
# Logged in users can create new text posts; link in navbar.
# After creating a new post, users see all posts ever created.

# Users can view other users' profiles through links on posts or the user index page, and from there will be able to follow other users.
#	- currently follows don't work, so the :show, :create, and :edit routes are hidden.
#	- a follow or unfollow button will show depending on the current follow status between the current user and the page the user is on
#	- on the current user's profile an edit link shows instead of a follow link.

# Once follows are working, logged in users will be able to see a feed of posts only from users they follow by clicking on the blog logo.
# Users will be able to view who follows them and who they follow on their profile (show) page.
# Using the 'back' link from your profile will show an index of all blog users.
