# INCORRECT: Add a user and a group to the Pre-Windows 2000 Compatible Access group

# Add user emily.carter (HR Specialist)
Add-ADGroupMember -Identity "Pre-Windows 2000 Compatible Access" -Members emily.carter

# Add group SG-Doctor (Doctors)
Add-ADGroupMember -Identity "Pre-Windows 2000 Compatible Access" -Members "SG-Doctor"
