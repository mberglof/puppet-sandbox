require 'facter'

Facter.add(:fc_role) do
  setcode do
    fc_role = nil
    if name = Facter::Util::Resolution.exec('hostname -f')
      if name =~ /(.*?)\W/
        fc_role = $1
      else
        fc_role = name
      end
    end
    fc_role
  end
end
