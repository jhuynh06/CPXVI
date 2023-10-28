<# Prerequisites (Run each in Terminal)
Install-Module -Name AuditPolicyDsc
Install-Module -Name SecurityPolicyDsc
Install-Module -Name NetworkingDsc
Install-Module -Name PSDesiredStateConfiguration
#>

<# Run stuff below to allow permissions
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Unrestricted
#>

<# Execute file (Run in PowerShell with admin)
./windows10.ps1
Start-DscConfiguration -Path .\Windows10Hardening  -Force -Verbose -Wait
#>

# Starting configuration
# [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Write-Host = 'Starting Configuration'
Configuration Windows10Hardening {
  param (
    [string[]]$ComputerName = 'localhost'
  )
  Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
  Import-DscResource -ModuleName 'AuditPolicyDsc'
  Import-DscResource -ModuleName 'SecurityPolicyDsc'
  Import-DscResource -ModuleName 'NetworkingDsc'

  Node $ComputerName {
    # Win+R >> secpol.msc >> Account Policy 
    AccountPolicy AccountPolicies {
      Name = 'PasswordPolicies'

      Enforce_password_history = '24'

      Minimum_Password_Age = '2'

      Maximum_Password_Age = '50'

      Minimum_Password_Length = '14'

      Password_must_meet_complexity_requirements = 'Enabled'

      Store_passwords_using_reversible_encryption = 'Disabled'
      
      Account_lockout_threshold = '5'
      
      Account_lockout_duration = '15'
      
      Reset_account_lockout_counter_after = '15'
    }
    
    # Win+R >> secpol.msc >> Local Policies >> Audit Policies
    $Folder = 'C:\temp'
    if (-Not(Test-Path -Path $Folder)) {
        New-Item -Path 'c:\temp' -ItemType Directory
    }
    secedit /export /cfg c:\temp\secpol.cfg
    $secpol = (Get-Content C:\temp\secpol.cfg)
    
    $Value = $secpol | where{ $_ -like "AuditSystemEvents*" }
    $Index = [array]::IndexOf($secpol,$Value)
    
    if($Value -ne "AuditSystemEvents = 3") {
        $secpol.item($Index) = "AuditSystemEvents = 3"
    }
    
    $Value = $secpol | where{ $_ -like "AuditLogonEvents*" }
    $Index = [array]::IndexOf($secpol,$Value)
    
    if($Value -ne "AuditLogonEvents = 3") {
        $secpol.item($Index) = "AuditLogonEvents = 3"
    }
    
    $Value = $secpol | where{ $_ -like "AuditObjectAccess*" }
    $Index = [array]::IndexOf($secpol,$Value)
    
    if($Value -ne "AuditObjectAccess = 3") {
        $secpol.item($Index) = "AuditObjectAccess = 3"
    }
    
    $Value = $secpol | where{ $_ -like "AuditPrivilegeUse*" }
    $Index = [array]::IndexOf($secpol,$Value)
    
    if($Value -ne "AuditPrivilegeUse = 3") {
        $secpol.item($Index) = "AuditPrivilegeUse = 3"
    }
    
    $Value = $secpol | where{ $_ -like "AuditPolicyChange*" }
    $Index = [array]::IndexOf($secpol,$Value)
    
    if($Value -ne "AuditPolicyChange = 3") {
        $secpol.item($Index) = "AuditPolicyChange = 3"
    }
    
    $Value = $secpol | where{ $_ -like "AuditAccountManage*" }
    $Index = [array]::IndexOf($secpol,$Value)
    
    if($Value -ne "AuditAccountManage = 3") {
        $secpol.item($Index) = "AuditAccountManage = 3"
    }
    
    $Value = $secpol | where{ $_ -like "AuditProcessTracking*" }
    $Index = [array]::IndexOf($secpol,$Value)
    
    if($Value -ne "AuditProcessTracking = 3") {
        $secpol.item($Index) = "AuditProcessTracking = 3"
    }
    
    $Value = $secpol | where{ $_ -like "AuditDSAccess*" }
    $Index = [array]::IndexOf($secpol,$Value)
    
    if($Value -ne "AuditDSAccess = 3") {
        $secpol.item($Index) = "AuditDSAccess = 3"
    }
    
    $Value = $secpol | where{ $_ -like "AuditAccountLogon*" }
    $Index = [array]::IndexOf($secpol,$Value)
    
    if($Value -ne "AuditAccountLogon = 3") {
        $secpol.item($Index) = "AuditAccountLogon = 3"
    }
    
    $secpol | out-file c:\temp\secpol.cfg -Force
    
    
    secedit /configure /db c:\windows\security\local.sdb /cfg c:\temp\secpol.cfg /areas SECURITYPOLICY
    
    Remove-Item -Path 'c:\temp' -Recurse
    
    # Win+R >> secpol.msc >> Local Policies >> User Rights Assignment
    UserRightsAssignment Accesscredentialmanagerasatrustedcaller {
      Policy = 'Access_credential_manager_as_a_trusted_caller'
      Identity = 'No One'
    }
    
    UserRightsAssignment Accessthiscomputerfromthenetwork {
      Policy = 'Access_this_computer_from_the_network'
      Identity = 'Administrators, Remote Desktop Users'
    }
     
    UserRightsAssignment Actaspartoftheoperatingsystem {
      Policy = 'Act_as_part_of_the_operating_system'
      Identity = 'No One'
    }
    
    UserRightsAssignment Adjustmemoryquotasforaprocess {
      Policy = 'Adjust_memory_quotas_for_a_process'
      Identity = 'Administrators, LOCAL SERVICE, NETWORK SERVICE'
    }
    
    UserRightsAssignment Alloowlogonlocally {
      Policy = 'Allow_log_on_locally'
      Identity = 'Administrators, Users'
    }
    
    UserRightsAssignment AllowlogonthroughRemoteDesktopServices {
      Policy = 'Allow_log_on_through_Remote_Desktop_Services'
      Identity = 'Administrators, Remote Desktop Users'
    }
    
    UserRightsAssignment Changethesystemtime {
      Policy = 'Change_the_system_time'
      Identity = 'Administrators'
    }
    
    UserRightsAssignment Changethetimezone {
      Policy = 'Change_the_time_zone'
      Identity = 'Administrators, LOCAL SERVICE, Users'
    }
    
    
    UserRightsAssignment Createglobalobjects {
      Policy = 'Create_global_objects'
      Identity = 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'
    }
    
    UserRightsAssignment Createpermanentsharedobjects {
      Policy = 'Create_permanent_shared_objects'
      Identity = 'No One'
    }
    
    UserRightsAssignment Createsymboliclinks {
      Policy = 'Create_symbolic_links'
      Identity = 'Administrators'
    }  
    
    UserRightsAssignment Debugprograms {
      Policy = 'Debug_programs'
      Identity = 'Adminstrators'
    }
    
    UserRightsAssignment Denyaccesstothiscomputerfromthenetwork {
      Policy = 'Deny_access_to_this_computer_from_the_network'
      Identity = 'Guests, Local account'
    }
    
    UserRightsAssignment Denylogonasabatchjob {
      Policy = 'Deny_log_on_as_a_batch_job'
      Identity = 'Guests'
    }
    
    UserRightsAssignment Denylogonasaservice {
      Policy = 'Deny_log_on_as_a_service'
      Identity = 'Guests'
    }
    
    UserRightsAssignment Denylogonlocally {
      Policy = 'Deny_log_on_locally'
      Identity = 'Guests'
    } 
    
    
    UserRightsAssignment Enablecomputeranduseraccountstobetrustedfordelegation {
      Policy = 'Enable_computer_and_user_accounts_to_be_trusted_for_delegation'
      Identity = 'No One'
    }
    
    UserRightsAssignment Generatesecurityaudits {
      Policy = 'Generate_security_audits'
      Identity = 'LOCAL SERVICE, NETWORK SERVICE'
    }
    
    UserRightsAssignment Impersonateaclientafterauthentication {
      Policy = 'Impersonate_a_client_after_authentication'
      Identity = 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'
    }
    
    UserRightsAssignment Increaseschedulingpriority {
      Policy = 'Increase_scheduling_priority'
      Identity = 'Administrators, Window Manager\Window Manager Group'
    }
    
    UserRightsAssignment Loadandunloaddevicedrivers {
      Policy = 'Load_and_unload_device_drivers'
      Identity = 'Administrators'
    }
    
    UserRightsAssignment Lockpagesinmemory {
      Policy =  'Lock_pages_in_memory'
      Identity = 'No one'
    }
    SecurityOption AccountSecurityOptions {
      Name = 'AccountSecurityOptions'
      
      # Accounts
      #Accounts_Administrator_account_status = 'Disabled'
      
      #Accounts_Block_Microsoft_accounts = "Users cant add or log on with Microsoft Accounts"
      
      Accounts_Guest_account_status = 'Disabled'
      
      Accounts_Limit_local_account_use_of_blank_passwords_to_console_logon_only = 'Enabled'
      
      # Audit
      Audit_Force_audit_policy_subcategory_settings_Windows_Vista_or_later_to_override_audit_policy_category_settings = 'Enabled'
      
      Audit_Shut_down_system_immediately_if_unable_to_log_security_audits = 'Disabled'
      
      # Devices
      Devices_Allowed_to_format_and_eject_removable_media = 'Administrators and Interactive Users'
      
      Devices_Prevent_users_from_installing_printer_drivers = 'Enabled'

      Devices_Allow_undock_without_having_to_log_on = 'Disabled'

      Devices_Restrict_CD_ROM_access_to_locally_logged_on_user_only = 'Enabled'

      Devices_Restrict_floppy_access_to_locally_logged_on_user_only = 'Enabled'
      
      # Domain member
      Domain_member_Digitally_encrypt_or_sign_secure_channel_data_always = 'Enabled'
      
      Domain_member_Digitally_encrypt_secure_channel_data_when_possible = 'Enabled'
      
      Domain_member_Digitally_sign_secure_channel_data_when_possible = 'Enabled'
      
      Domain_member_Disable_machine_account_password_changes = 'Disabled'
      
      Domain_member_Maximum_machine_account_password_age = '30'
      
      Domain_member_Require_strong_windows_2000_or_later_session_key = 'Enabled'

      
      # Interactive logon
      Interactive_logon_Do_not_require_CTRL_ALT_DEL = 'Disabled'
        
      Interactive_logon_Display_user_information_when_the_session_is_locked = 'Do not display user information'

      Interactive_logon_Do_not_display_last_user_name = 'Enabled'
      
      Interactive_logon_Machine_account_lockout_threshold = '10'
      
      Interactive_logon_Machine_inactivity_limit = '900'
      
      Interactive_logon_Message_text_for_users_attempting_to_log_on = 'Authorized users only.'
      
      Interactive_logon_Message_title_for_users_attempting_to_log_on = 'Authorized users only.'
      
      Interactive_logon_Number_of_previous_logons_to_cache_in_case_domain_controller_is_not_available = '4'
      
      Interactive_logon_Prompt_user_to_change_password_before_expiration = '5'
      
      Interactive_logon_Smart_card_removal_behavior = 'Lock Workstation'
      
      # Microsoft network client
      Microsoft_network_client_Digitally_sign_communications_always = 'Enabled'
      
      Microsoft_network_client_Digitally_sign_communications_if_server_agrees = 'Enabled'
      
      Microsoft_network_client_Send_unencrypted_password_to_third_party_SMB_servers = 'Disabled'
      
      # Microsoft network server
      Microsoft_network_server_Amount_of_idle_time_required_before_suspending_session = '15'
      
      Microsoft_network_server_Digitally_sign_communications_always = 'Enabled'
      
      Microsoft_network_server_Digitally_sign_communications_if_client_agrees = 'Enabled'
      
      Microsoft_network_server_Disconnect_clients_when_logon_hours_expire = 'Enabled'
      
      Microsoft_network_server_Server_SPN_target_name_validation_level = 'Accept if provided by client'
      
      # Network access
      Network_access_Allow_anonymous_SID_Name_translation = 'Disabled'
      
      Network_access_Do_not_allow_anonymous_enumeration_of_SAM_accounts = 'Enabled'
      
      Network_access_Do_not_allow_anonymous_enumeration_of_SAM_accounts_and_shares = 'Enabled'
      
      Network_access_Do_not_allow_storage_of_passwords_and_credentials_for_network_authentication = 'Enabled'
      
      Network_access_Let_Everyone_permissions_apply_to_anonymous_users = 'Disabled'
      
      Network_access_Named_Pipes_that_can_be_accessed_anonymously = 'None'
      
      Network_access_Remotely_accessible_registry_paths = 'System\CurrentControlSet\Control\ProductOptions|#|System\CurrentControlSet\Control\Server Applications|#|Software\Microsoft\Windows NT\CurrentVersion'
      
      Network_access_Remotely_accessible_registry_paths_and_subpaths = 'System\CurrentControlSet\Control\Print\Printers|#|System\CurrentControlSet\Services\Eventlog|#|Software\Microsoft\OLAP Server|#|Software\Microsoft\Windows NT\CurrentVersion\Print|#|Software\Microsoft\Windows NT\CurrentVersion\Windows|#|System\CurrentControlSet\Control\ContentIndex|#|System\CurrentControlSet\Control\Terminal Server|#|System\CurrentControlSet\Control\Terminal Server\UserConfig|#|System\CurrentControlSet\Control\Terminal Server\DefaultUserConfiguration|#|Software\Microsoft\Windows NT\CurrentVersion\Perflib|#|System\CurrentControlSet\Services\SysmonLog'
      
      Network_access_Restrict_anonymous_access_to_Named_Pipes_and_Shares = 'Enabled'
      
      # Network_access_Restrict_clients_allowed_to_make_remote_calls_to_SAM = 'Administrators: Remote Access: Allow'
      
      Network_access_Shares_that_can_be_accessed_anonymously = 'None'
      
      Network_access_Sharing_and_security_model_for_local_accounts = 'Classic - local users authenticate as themselves'
      
      # Network security
      Network_security_Allow_Local_System_to_use_computer_identity_for_NTLM = 'Enabled'
      
      Network_security_Allow_LocalSystem_NULL_session_fallback = 'Disabled'
      
      Network_security_Allow_PKU2U_authentication_requests_to_this_computer_to_use_online_identities = 'Disabled'
      
      Network_security_Configure_encryption_types_allowed_for_Kerberos = 'DES_CBC_CRC', 'DES_CBC_MD5', 'RC4_HMAC_MD5', 'AES128_HMAC_SHA1', 'AES256_HMAC_SHA1', 'FUTURE'
      
      Network_security_Do_not_store_LAN_Manager_hash_value_on_next_password_change = 'Enabled'
      
      Network_security_Force_logoff_when_logon_hours_expire = 'Enabled'
      
      Network_security_LAN_Manager_authentication_level = 'Send NTLMv2 responses only'
      
      Network_security_LDAP_client_signing_requirements = 'Negotiate signing'
      
      Network_security_Minimum_session_security_for_NTLM_SSP_based_including_secure_RPC_clients = 'Both options checked'

      Network_security_Minimum_session_security_for_NTLM_SSP_based_including_secure_RPC_servers = 'Both options checked'

      # System cryptography
      System_cryptography_Force_strong_key_protection_for_user_keys_stored_on_the_computer = 'User is prompted when the key is first used'
      
      # System objects
      System_objects_Require_case_insensitivity_for_non_Windows_subsystems = 'Enabled'
      
      System_objects_Strengthen_default_permissions_of_internal_system_objects_eg_Symbolic_Links = 'Enabled'
      
      # User Account Control
      User_Account_Control_Admin_Approval_Mode_for_the_Built_in_Administrator_account = 'Enabled'
      
      User_Account_Control_Behavior_of_the_elevation_prompt_for_administrators_in_Admin_Approval_Mode = 'Prompt for consent on the secure desktop'
      
      User_Account_Control_Behavior_of_the_elevation_prompt_for_standard_users = 'Automatically deny elevation request'
      
      User_Account_Control_Detect_application_installations_and_prompt_for_elevation = 'Enabled'
      
      User_Account_Control_Only_elevate_UIAccess_applications_that_are_installed_in_secure_locations = 'Enabled'
      
      User_Account_Control_Run_all_administrators_in_Admin_Approval_Mode = 'Enabled'
      
      User_Account_Control_Switch_to_the_secure_desktop_when_prompting_for_elevation = 'Enabled'
      
      User_Account_Control_Virtualize_file_and_registry_write_failures_to_per_user_locations = 'Enabled'
    }
    
  }
  
}

Windows10Hardening
