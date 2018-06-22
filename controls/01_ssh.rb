# frozen_string_literal: true
conn_options = {
  viserver: attribute('viserver', description: 'The server you want to connect to'),
  username: attribute('username', description: 'Username to connect as'),
  password: attribute('password', description: 'Password to connect with')
}

control '1-disable-ssh' do
  cmd = 'Get-VMhost | Get-VMHostService | Where {$_.key -eq "TSM-SSH" -and $_.running -eq $False}'
  title 'Disable SSH'
  impact 0.5
  desc '
  Disable Secure Shell (SSH) for each ESXi host to prevent remote access to the ESXi shell.
  only enable if needed for troubleshooting or diagnostics.
  '

  describe powercli_command(cmd, conn_options) do
    its('exit_status') { should cmp 0 }
    its('stdout') { should_not cmp '' }
  end
end
