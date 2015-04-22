require 'facter'

Facter.add(:fc_proj) do
  setcode do
    fc_proj = nil
    if name = Facter::Util::Resolution.exec('hostname -f')
      if name =~ /\w+\.(\w+)/
        fc_proj = $1
      else
        fc_proj = name
      end
    end
    fc_proj
  end
end
