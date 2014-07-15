
create_resources(host, hiera_hash('hosts'))

include windows::git
include windows::maven

include windows::npanday::required
include windows::npanday::optional
include windows::npanday::tests

import 'windows/*.pp'
import 'windows/npanday/*.pp'
