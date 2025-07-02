<a href="https://github.com/camaraproject/SessionInsights/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/camaraproject/SessionInsights?style=plastic"></a>
<a href="https://github.com/camaraproject/SessionInsights/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/camaraproject/SessionInsights?style=plastic"></a>
<a href="https://github.com/camaraproject/SessionInsights/pulls" title="Open Pull Requests"><img src="https://img.shields.io/github/issues-pr/camaraproject/SessionInsights?style=plastic"></a>
<a href="https://github.com/camaraproject/SessionInsights/graphs/contributors" title="Contributors"><img src="https://img.shields.io/github/contributors/camaraproject/SessionInsights?style=plastic"></a>
<a href="https://github.com/camaraproject/SessionInsights" title="Repo Size"><img src="https://img.shields.io/github/repo-size/camaraproject/SessionInsights?style=plastic"></a>
<a href="https://github.com/camaraproject/SessionInsights/blob/main/LICENSE" title="License"><img src="https://img.shields.io/badge/License-Apache%202.0-green.svg?style=plastic"></a>
<a href="https://github.com/camaraproject/SessionInsights/releases/latest" title="Latest Release"><img src="https://img.shields.io/github/release/camaraproject/SessionInsights?style=plastic"></a>
<a href="https://github.com/camaraproject/Governance/blob/main/ProjectStructureAndRoles.md" title="Sandbox API Repository"><img src="https://img.shields.io/badge/Sandbox%20API%20Repository-yellow?style=plastic"></a>

# SessionInsights

Sandbox API Repository to describe, develop, document, and test the SessionInsights Service API(s) in group with [Connectivity Insights](https://lf-camaraproject.atlassian.net/wiki/spaces/CAM/pages/93946006/Connectivity+Insights)

* API Repository [wiki page](https://lf-camaraproject.atlassian.net/wiki/x/44CaBQ)

## Scope

* Concept and Service APIs for “SessionInsights” (see APIBacklog.md) <!-- Alternative for multiple APIs: "Service APIs for "SessionInsights” -->
* The API provides an API Consumer with the ability to:
  - report application KPIs to network operator
  - receive score from network operator
  - receive root cause analysis and recommended corrective actions
  - request service improvements
* Note: in first steps the concept will be described with user stories. The relation to existing APIs (e.g. application-profiles, connectivity-insights, quality-on-demand) will be describe to identify if any and which new API(s) are needed
* Describe the concept, develop, document, and test the APIs
* Started: September 2024
* Originally proposed as Quality by Design (QbD) - has been renamed to SessionInsights to better reflect the scope of the API

## Release Information

The repository has no (pre)releases yet, work in progress is within the main branch.
<!-- Optional: an explicit listing of the latest (pre-)release with additional information, e.g. links to the API definitions -->
<!-- In addition use/uncomment one or multiple the following alternative options when becoming applicable -->
<!-- Pre-releases of this sub project are available in https://github.com/camaraproject/SessionInsights/releases -->
<!-- The latest public release is available here: https://github.com/camaraproject/SessionInsights/releases/latest -->
<!-- For changes see [CHANGELOG.md](https://github.com/camaraproject/SessionInsights/blob/main/CHANGELOG.md) -->

## Contributing
* Meetings are held virtually
    * Schedule: Bi-weekly on Wednesday at 8AM PST (see https://wiki.camaraproject.org/display/CAM/ConnectivityInsights)
    * [Registration / Join](https://zoom-lfx.platform.linuxfoundation.org/meeting/92345695827?password=35dff2b2-058d-44de-bd7e-67d08c9e9f9d)
    * Minutes: Access [meeting minutes](https://lf-camaraproject.atlassian.net/wiki/x/vzve)
* Mailing List
    * Subscribe / Unsubscribe to the mailing list of this Sub Project https://lists.camaraproject.org/g/sp-coi.
    * A message to the community of this Sub Project can be sent using sp-coi@lists.camaraproject.org.

## Test megalinter
