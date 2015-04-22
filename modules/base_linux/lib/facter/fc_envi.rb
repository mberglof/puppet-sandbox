require 'facter'

Facter.add(:fc_envi) do
  setcode do
    fc_envi = nil
    if name = Facter::Util::Resolution.exec('hostname -f')
      if name =~ /\w+\.\w+\.(\w+)/
        fc_envi = $1
      else
        fc_envi = name
      end
    end
    fc_envi
  end
end
