# frozen_string_literal: true

control '1-disable-ssh' do
  title 'Disable SSH'
  impact 0.5
  desc <<-DESCRIPTION
    Disable Secure Shell (SSH) for each ESXi host to prevent remote access to
    the ESXi shell. Only enable if needed for troubleshooting or diagnostics.
  DESCRIPTION

  cmd = 'Get-VMhost | Get-VMHostService | Where {$_.key -eq "TSM-SSH" -and $_.running -eq $False}'
  describe powercli_command(cmd) do
    its('exit_status') { should cmp 0 }
    its('stdout') { should_not cmp '' }
  end
end
