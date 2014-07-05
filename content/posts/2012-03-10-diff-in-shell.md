---
title: "diff in shell"
author: "Caius Durling"
created_at: 2012-03-10 14:11:34 +0000
---

# diff munin_passenger_status <(sed -re 's@#!/usr/bin/env ruby@#!/opt/ruby1.9.3-p0/bin/ruby@' munin_passenger_status)
1c1
< #!/usr/bin/env ruby
---
> #!/opt/ruby1.9.3-p0/bin/ruby

