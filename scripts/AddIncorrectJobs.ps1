# Incorrectly add users to groups that do not match their job titles

# Add an HR Specialist to the Doctor group
Add-ADGroupMember -Identity "SG-Doctor" -Members emily.carter

# Add a Security Analyst to the Janitor group
Add-ADGroupMember -Identity "SG-Janitor" -Members isabella.chen

# Add a Medical Assistant to the SysAdmin group
Add-ADGroupMember -Identity "SG-SysAdmin" -Members ethan.brooks

# Add a Medical Assistant to the SecurityAngalyst group
Add-ADGroupMember -Identity "SG-Security_Analyst" -Members brooklyn.reed

# Add a Janitor to the Nurse group
Add-ADGroupMember -Identity "SG-Nurse" -Members william.ortiz

# Add an Executive Assistant to the Maintenance group
Add-ADGroupMember -Identity "SG-Maintenance" -Members noah.james
