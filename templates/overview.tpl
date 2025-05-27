<!-- Toastr CSS for notifications -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet"/>
<!-- World map -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<!-- Chart.js CSS (optional sizing) -->
<style>
    .chart-container { width: 100%; height: 300px; margin: 10px 0; }
    .attack-details h5 { margin-top: 0; }
</style>

<!-- IP Selector -->
<div class="row mb-3">
    <div class="col-sm-12">
        <div class="card">
            <div class="ticket-reply">
                <div class="ticket-reply-top">
                    <div class="user">
                        <div class="user-info">
                            <span class="name">
                                <i class="fas fa-network-wired"></i>
                                Select IP to Manage
                            </span>
                        </div>
                    </div>
                </div>
                <div class="ticket-reply-message markdown-content">
                    <select id="ipSelector" class="form-control" style="max-width: 300px;">
                        {foreach from=$services item=service}
                            <option value="{$service.ip}">{$service.ip} - {$service.hostname}</option>
                        {/foreach}
                    </select>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Main Firewall Block with Tabs -->
<div class="row">
    <div class="col-sm-12">
        <div class="card mb-3">
            <div class="ticket-reply">
                <div class="ticket-reply-top">
                    <div class="user">
                        <div class="user-info">
                            <span class="name">
                                <i class="fas fa-shield"></i>
                                Firewall
                            </span>
                        </div>
                        <div class="date" style="align-self: auto;">
                            <img src="https://neoprotect.net/banner.png" width="80px">
                        </div>
                    </div>
                </div>
                <div class="ticket-reply-message markdown-content">
                    <!-- Tab Navigation -->
                    <ul class="nav nav-tabs" id="firewallTabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="settings-tab" data-toggle="tab" href="#settings" role="tab" aria-controls="settings" aria-selected="true">
                               Settings
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="filter-tab" data-toggle="tab" href="#filter" role="tab" aria-controls="filter" aria-selected="false">
                               GEO/ASN Filter
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="thresholds-tab" data-toggle="tab" href="#thresholds" role="tab" aria-controls="thresholds" aria-selected="false">
                                Thresholds
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="limits-tab" data-toggle="tab" href="#limits" role="tab" aria-controls="limits" aria-selected="false">
                                Limits
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="predefinidos-tab" data-toggle="tab" href="#profiles" role="tab" aria-controls="predefinidos" aria-selected="false">
                                Profiles
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="attacks-tab" data-toggle="tab" href="#attacks" role="tab" aria-controls="attacks" aria-selected="false">
                                Attacks
                            </a>
                        </li>
                    </ul>

                    <!-- Tab Content -->
                    <div class="tab-content" id="myTabContent">

                        <div class="tab-pane fade show active" id="settings" role="tabpanel" aria-labelledby="settings-tab">
                            <br>

                            <div class="card mb-3">
                                <div class="ticket-reply-top">
                                    <div class="user">
                                        <div class="user-info">
                                            <span class="name">
                                                Mitigation Settings
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="ticket-reply">
                                    <div class="ticket-reply-message markdown-content">
                                        <div class="form-row">
                                            <div class="col-md-3">
                                                <label for="mitigationDuration">Mitigation duration (seconds)</label>
                                                <input
                                                        type="number"
                                                        id="attackDuration"
                                                        name="attackDuration"
                                                        class="form-control"
                                                        value=""
                                                        required
                                                >
                                            </div>
                                        </div>

                                        <div class="form-check mt-3">
                                            <input
                                                    type="checkbox"
                                                    class="form-check-input"
                                                    id="allowEgress"
                                                    name="allowEgress"
                                            >
                                            <label class="form-check-label" for="allowEgress">
                                                Allow Egress
                                            </label>
                                            <br><small>Allow incoming packets that are related to outgoing (egress) connections.</small>
                                        </div>

                                        <div class="form-check mt-3">
                                            <input
                                                    type="checkbox"
                                                    class="form-check-input"
                                                    id="ackCheck"
                                                    name="ackCheck"
                                            >
                                            <label class="form-check-label" for="tcpStrictMode">
                                                TCP Strict Mode
                                            </label>
                                            <br><small>Additional TCP checks to validate established connections.</small>
                                        </div>
                                    </div>
                                </div>
                            </div>


                            <div class="card mb-3">
                                <div class="ticket-reply-top">
                                    <div class="user">
                                        <div class="user-info">
                                            <span class="name">
                                                Stateful Filter
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="ticket-reply">
                                    <div class="ticket-reply-message markdown-content">
                                        <div class="form-check">
                                            <input
                                                    type="checkbox"
                                                    class="form-check-input"
                                                    id="symmetricFiltering"
                                                    name="symmetricFiltering"
                                            >
                                            <label class="form-check-label" for="symmetricFiltering">
                                                Symmetric filtering
                                            </label>
                                            <br><small>Enable full stateful mitigation by inspecting both incoming and outgoing traffic. This feature does not work with asymmetric routing.</small>
                                        </div>

                                        <div id="basicSymmetricContainer" style="display: none;" class="form-check mt-3">
                                            <input
                                                    type="checkbox"
                                                    class="form-check-input"
                                                    id="symmetricFiltering2"
                                                    name="symmetricFiltering2"
                                            >
                                            <label class="form-check-label" for="symmetricFiltering2">
                                                Basic symmetric filtering
                                            </label>
                                        </div>
                                    </div>
                                </div>

                            </div>


                            <button type="button" class="btn btn-primary mt-3 saveSettingsBtn">
                                Save
                            </button>

                        </div>

                        <div class="tab-pane fade" id="thresholds" role="tabpanel" aria-labelledby="thresholds-tab">
                            <br>

                            <div class="row">
                                <div class="col-lg-6">
                                    <div class="card mb-3">
                                        <div class="ticket-reply-top">
                                            <div class="user">
                                                <div class="user-info">
                                            <span class="name">
                                               TCP-SYN
                                            </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="ticket-reply">
                                            <div class="ticket-reply-message markdown-content">
                                                <div class="form-row">
                                                    <label for="mitigationDuration">TCP-SYN threshold</label>
                                                    <input
                                                            type="number"
                                                            id="synThreshold"
                                                            name="synThreshold"
                                                            class="form-control"
                                                            value=""
                                                            required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="card mb-3">
                                        <div class="ticket-reply-top">
                                            <div class="user">
                                                <div class="user-info">
                                            <span class="name">
                                               TCP-ACK
                                            </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="ticket-reply">
                                            <div class="ticket-reply-message markdown-content">
                                                <div class="form-row">
                                                    <label for="mitigationDuration">TCP ACK threshold</label>
                                                    <input
                                                            type="number"
                                                            id="ackThreshold"
                                                            name="ackThreshold"
                                                            class="form-control"
                                                            value=""
                                                            required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="card mb-3">
                                        <div class="ticket-reply-top">
                                            <div class="user">
                                                <div class="user-info">
                                            <span class="name">
                                               First Fragments
                                            </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="ticket-reply">
                                            <div class="ticket-reply-message markdown-content">
                                                <div class="form-row">
                                                    <label for="mitigationDuration">First fragment threshold</label>
                                                    <input
                                                            type="number"
                                                            id="firstFragmentThreshold"
                                                            name="firstFragmentThreshold"
                                                            class="form-control"
                                                            value=""
                                                            required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="card mb-3">
                                        <div class="ticket-reply-top">
                                            <div class="user">
                                                <div class="user-info">
                                            <span class="name">
                                              Fragments
                                            </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="ticket-reply">
                                            <div class="ticket-reply-message markdown-content">
                                                <div class="form-row">
                                                    <label for="mitigationDuration">Fragment threshold</label>
                                                    <input
                                                            type="number"
                                                            id="fragmentThreshold"
                                                            name="fragmentThreshold"
                                                            class="form-control"
                                                            value=""
                                                            required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="card mb-3">
                                        <div class="ticket-reply-top">
                                            <div class="user">
                                                <div class="user-info">
                                            <span class="name">
                                               UDP AMP
                                            </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="ticket-reply">
                                            <div class="ticket-reply-message markdown-content">
                                                <div class="form-row">
                                                    <label for="mitigationDuration">UDP AMP threshold</label>
                                                    <input
                                                            type="number"
                                                            id="ampThreshold"
                                                            name="ampThreshold"
                                                            class="form-control"
                                                            value=""
                                                            required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="card mb-3">
                                        <div class="ticket-reply-top">
                                            <div class="user">
                                                <div class="user-info">
                                            <span class="name">
                                              UDP
                                            </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="ticket-reply">
                                            <div class="ticket-reply-message markdown-content">
                                                <div class="form-row">
                                                    <label for="mitigationDuration">UDP threshold</label>
                                                    <input
                                                            type="number"
                                                            id="udpThreshold"
                                                            name="udpThreshold"
                                                            class="form-control"
                                                            value=""
                                                            required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="card mb-3">
                                        <div class="ticket-reply-top">
                                            <div class="user">
                                                <div class="user-info">
                                            <span class="name">
                                               Symmetric filtering
                                            </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="ticket-reply">
                                            <div class="ticket-reply-message markdown-content">
                                                <div class="form-row">
                                                    <label for="mitigationDuration">Only enforce symmetric filtering if this threshold is reached</label>
                                                    <input
                                                            type="number"
                                                            id="symmetricThreshold"
                                                            name="symmetricThreshold"
                                                            class="form-control"
                                                            value=""
                                                            required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <button type="button" class="btn btn-primary mt-3 saveSettingsBtn">
                                Save
                            </button>

                        </div>

                        <div class="tab-pane fade" id="limits" role="tabpanel" aria-labelledby="limits-tab">
                            <br>

                            <div class="row">
                                <div class="col-lg-6">
                                    <div class="card mb-3">
                                        <div class="ticket-reply-top">
                                            <div class="user">
                                                <div class="user-info">
                                            <span class="name">
                                               TCP packets/s
                                            </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="ticket-reply">
                                            <div class="ticket-reply-message markdown-content">
                                                <div class="form-row">
                                                    <label for="mitigationDuration">Limit the maximum amount of packets per second per established TCP connection. Note that changes to this value may affect established connections.</label>
                                                    <input
                                                            type="number"
                                                            id="tcpConnLimit"
                                                            name="tcpConnLimit"
                                                            class="form-control"
                                                            value=""
                                                            required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="card mb-3">
                                        <div class="ticket-reply-top">
                                            <div class="user">
                                                <div class="user-info">
                                            <span class="name">
                                               TCP bytes/s
                                            </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="ticket-reply">
                                            <div class="ticket-reply-message markdown-content">
                                                <div class="form-row">
                                                    <label for="mitigationDuration">Limit the maximum amount of bytes per second per established TCP connection. Note that changes to this value may affect established connections.</label>
                                                    <input
                                                            type="number"
                                                            id="tcpConnBytesLimit"
                                                            name="tcpConnBytesLimit"
                                                            class="form-control"
                                                            value=""
                                                            required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="card mb-3">
                                        <div class="ticket-reply-top">
                                            <div class="user">
                                                <div class="user-info">
                                            <span class="name">
                                               UDP packets/s
                                            </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="ticket-reply">
                                            <div class="ticket-reply-message markdown-content">
                                                <div class="form-row">
                                                    <label for="mitigationDuration">Limit the maximum amount of packets per second per established UDP connection. Note that changes to this value may affect established connections.</label>
                                                    <input
                                                            type="number"
                                                            id="udpConnLimit"
                                                            name="udpConnLimit"
                                                            class="form-control"
                                                            value=""
                                                            required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="card mb-3">
                                        <div class="ticket-reply-top">
                                            <div class="user">
                                                <div class="user-info">
                                            <span class="name">
                                              UDP bytes/s
                                            </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="ticket-reply">
                                            <div class="ticket-reply-message markdown-content">
                                                <div class="form-row">
                                                    <label for="mitigationDuration">Limit the maximum amount of bytes per second per established UDP connection. Note that changes to this value may affect established connections.</label>
                                                    <input
                                                            type="number"
                                                            id="udpConnBytesLimit"
                                                            name="udpConnBytesLimit"
                                                            class="form-control"
                                                            value=""
                                                            required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="card mb-3">
                                        <div class="ticket-reply-top">
                                            <div class="user">
                                                <div class="user-info">
                                            <span class="name">
                                               TCP-SYN
                                            </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="ticket-reply">
                                            <div class="ticket-reply-message markdown-content">
                                                <div class="form-row">
                                                    <label for="mitigationDuration">Limit the maximum amount of TCP-SYN packets (new TCP connections), which may be forwarded to your network.</label>
                                                    <input
                                                            type="number"
                                                            id="synLimit"
                                                            name="synLimit"
                                                            class="form-control"
                                                            value=""
                                                            required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="card mb-3">
                                        <div class="ticket-reply-top">
                                            <div class="user">
                                                <div class="user-info">
                                            <span class="name">
                                              ICMP
                                            </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="ticket-reply">
                                            <div class="ticket-reply-message markdown-content">
                                                <div class="form-row">
                                                    <label for="mitigationDuration">Limit the maximum amount of ICMP packets, which may be forwarded to your network.</label>
                                                    <input
                                                            type="number"
                                                            id="icmpLimit"
                                                            name="icmpLimit"
                                                            class="form-control"
                                                            value=""
                                                            required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="card mb-3">
                                        <div class="ticket-reply-top">
                                            <div class="user">
                                                <div class="user-info">
                                            <span class="name">
                                               UDP connections
                                            </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="ticket-reply">
                                            <div class="ticket-reply-message markdown-content">
                                                <div class="form-row">
                                                    <label for="mitigationDuration">UDP connection limit</label>
                                                    <input
                                                            type="number"
                                                            id="udpNewConnLimit"
                                                            name="udpNewConnLimit"
                                                            class="form-control"
                                                            value=""
                                                            required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="card mb-3">
                                        <div class="ticket-reply-top">
                                            <div class="user">
                                                <div class="user-info">
                                            <span class="name">
                                               UDP length anomaly limit
                                            </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="ticket-reply">
                                            <div class="ticket-reply-message markdown-content">
                                                <div class="form-row">
                                                    <label for="mitigationDuration">UDP length anomaly limit</label>
                                                    <input
                                                            type="number"
                                                            id="udpLengthBytesLimit"
                                                            name="udpLengthBytesLimit"
                                                            class="form-control"
                                                            value=""
                                                            required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>

                            <button type="button" class="btn btn-primary mt-3 saveSettingsBtn">
                                Save
                            </button>

                        </div>

                        <div class="tab-pane fade" id="attacks" role="tabpanel" aria-labelledby="attacks-tab">
                            <div id="attackLoadingIndicator" class="text-center my-3"></div>
                            <table class="table table-striped" id="attackHistoryTable">
                                <caption class="text-center">Actualizado automáticamente cada 60 segundos</caption>
                                <thead>
                                <tr>
                                    <th>Host</th>
                                    <th>Status</th>
                                    <th>Signature</th>
                                    <th>Start</th>
                                    <th>End</th>
                                    <th>PPS (packets per second)</th>
                                    <th>BTS (bits per second)</th>
                                    <th>Attack Info</th>
                                </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>

                        <div class="tab-pane fade" id="filter" role="tabpanel" aria-labelledby="filter-tab">
                            <br>

                            <div class="card mb-3">
                                <div class="ticket-reply-top">
                                    <div class="user">
                                        <div class="user-info">
                                            <span class="name">
                                                GEO / ASN filtering
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="ticket-reply">
                                    <div class="ticket-reply-message markdown-content">
                                        <div class="form-row">
                                            <label for="mitigationDuration">Country Block</label>
                                            <select class="form-control" id="countryBlockMode">
                                                <option value="0">Disabled</option>
                                                <option value="1">Blacklist</option>
                                                <option value="2">Whitelist</option>
                                            </select>
                                            <br><small>Decide which countries should be allowed or denied from connecting to your IP.</small>

                                            <div id="countryFilteringContainer" style="display: none;">
                                                <br>
                                                <div class="form-row mt-3">
                                                    <div class="col-md-6">
                                                        <select class="form-control" id="countrySelect">
                                                            <option value="">Loading countries...</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <button type="button" class="btn btn-secondary" id="addCountryBtn">Add Country</button>
                                                    </div>
                                                </div>

                                                <table class="table table-sm mt-3" id="countryListTable">
                                                    <thead>
                                                    <tr>
                                                        <th>Country</th>
                                                        <th>Action</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody>
                                                    </tbody>
                                                </table>
                                            </div>


                                        </div>

                                        <hr class="border-bottom border-3 border-dark " style="height:15px" />

                                        <div class="form-row">

                                            <label for="mitigationDuration">ASN Block</label>
                                            <select class="form-control" id="asnBlockMode">
                                                < <option value="0">Disabled</option>
                                                <option value="1">Blacklist</option>
                                                <option value="2">Whitelist</option>
                                            </select>
                                            <br><small>Decide which ASNs should be allowed or denied from connecting to your IP.</small>

                                            <div id="asnFilteringContainer" style="display: none;">
                                                <br>
                                                <div class="form-row mt-3">
                                                    <div class="col-md-6">
                                                        <input type="number" class="form-control" id="asnInput" placeholder="Enter ASN">
                                                    </div>
                                                    <div class="col-md-6">
                                                        <button type="button" class="btn btn-secondary" id="addAsnBtn">Add ASN</button>
                                                    </div>
                                                </div>

                                                <table class="table table-sm mt-3" id="asnListTable">
                                                    <thead>
                                                    <tr>
                                                        <th>ASN</th>
                                                        <th>Action</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody>
                                                    </tbody>
                                                </table>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>

                            <button type="button" class="btn btn-primary mt-3" id="saveAsnFiltering">
                                Save
                            </button>

                        </div>

                        <div class="tab-pane fade" id="profiles" role="tabpanel" aria-labelledby="profiles-tab">
                            <br>

                            <div class="card mb-3">
                                <div class="ticket-reply-top">
                                    <div class="user">
                                        <div class="user-info">
                                            <span class="name">
                                                Default Action
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="ticket-reply">
                                    <div class="ticket-reply-message markdown-content">
                                        <div class="form-row">
                                            <label for="mitigationDuration">The default action will be applied to any packet that does not match a profile.</label>
                                            <select class="form-control" id="defaultAction" name="defaultAction">
                                                <option value="FILTER">Filter</option>
                                                <option value="DROP">Drop</option>
                                            </select>
                                        </div>

                                        <button type="button" class="btn btn-primary mt-3" id="saveDefaultAction">
                                            Save
                                        </button>
                                    </div>
                                </div>
                            </div>


                            <div class="card mb-3">
                                <div class="ticket-reply-top">
                                    <div class="user">
                                        <div class="user-info">
                                            <span class="name">
                                                Profiles
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="ticket-reply">
                                    <div class="ticket-reply-message markdown-content">
                                        <div class="form-row">
                                            <label for="mitigationDuration">Configure profiles to adjust the mitigation of your IP.</label>
                                        </div>

                                        <button type="button" class="btn btn-success mt-3" id="createProfileBtn">
                                            Create Profile
                                        </button>

                                        <table class="table table-striped mt-3" id="profilesTable">
                                            <thead>
                                            <tr>
                                                <th>Ports</th>
                                                <th>Protocol</th>
                                                <th>Action</th>
                                                <th>Preset</th>
                                                <th>Notes</th>
                                                <th>Options</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>

                                    </div>
                                </div>
                            </div>

                            <div class="modal fade" id="profileModal" tabindex="-1" role="dialog" aria-labelledby="profileModalLabel" aria-hidden="true">
                                <div class="modal-dialog" role="document">
                                    <form id="profileForm">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="profileModalLabel">Create Profile</h5>
                                            </div>

                                            <div class="modal-body">
                                                <!-- Campo oculto para profileId en edición -->
                                                <input type="hidden" id="profileId" name="profileId" value="">

                                                <!-- Protocolo -->
                                                <div class="form-group">
                                                    <label for="protocolSelect">Protocol</label>
                                                    <select class="form-control" id="protocolSelect" name="protocol">
                                                        <option value="TCP">TCP</option>
                                                        <option value="UDP">UDP</option>
                                                        <option value="ICMP">ICMP</option>
                                                    </select>
                                                </div>

                                                <!-- Contenedor de Destination Port (para TCP/UDP) -->
                                                <div id="destinationPortContainer">
                                                    <!-- Selección de tipo de puerto -->
                                                    <div class="form-group">
                                                        <label for="dstPortType">Destination Port Type</label>
                                                        <select class="form-control" id="dstPortType">
                                                            <option value="individual">Individual Port</option>
                                                            <option value="range">Port Range</option>
                                                        </select>
                                                    </div>
                                                    <!-- Input para Individual Port -->
                                                    <div class="form-group" id="individualPortContainer">
                                                        <label for="dstPort">Destination Port</label>
                                                        <input type="number" class="form-control" id="dstPort" placeholder="Enter Port">
                                                    </div>
                                                    <!-- Inputs para Port Range -->
                                                    <div class="form-group" id="rangePortContainer" style="display:none;">
                                                        <label>Destination Port Range</label>
                                                        <div class="form-row">
                                                            <div class="col">
                                                                <input type="number" class="form-control" id="minDstPort" placeholder="Min Port">
                                                            </div>
                                                            <div class="col">
                                                                <input type="number" class="form-control" id="maxDstPort" placeholder="Max Port">
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Preset: se filtrarán según protocolo -->
                                                <div class="form-group" id="presetContainer">
                                                    <label for="presetSelect">Preset</label>
                                                    <select class="form-control" id="presetSelect" name="presetId">
                                                        <option value="">Loading presets...</option>
                                                    </select>
                                                </div>

                                                <!-- Notes -->
                                                <div class="form-group">
                                                    <label for="profileNotes">Notes</label>
                                                    <input type="text" class="form-control" id="profileNotes" name="notes" placeholder="Optional notes">
                                                </div>

                                            </div>

                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-primary" id="saveProfileBtn">Save Profile</button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Scripts -->
<!--<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    {literal}
    function getSelectedIp() {
        return $("#ipSelector").val() || "";
    }

    $("#ipSelector").change(function() {
        loadProfiles();
        getAttacks();
        getInfo();
        getAvailableCountries();
    });

    var ip = getSelectedIp();

    var asnList = [];
    var selectedCountryList = [];
    var availableCountries = [];
    var currentProfile = null;

    function loadPresets() {
        $.get("/modules/addons/neoprotect_module/ajax.php", { action: "getPresets", ip: ip }, function(data){
            var protocol = $("#protocolSelect").val();
            var filteredPresets = data.filter(function(preset){
                return preset.protocol === protocol;
            });
            var presetSelect = $("#presetSelect");
            presetSelect.empty();
            presetSelect.append("<option value=''>Select a preset</option>");
            filteredPresets.forEach(function(preset) {
                presetSelect.append("<option value='" + preset.id + "'>" + preset.name + "</option>");
            });
        });
    }

    function loadProfiles() {
        var ip = getSelectedIp();
        $.post("/modules/addons/neoprotect_module/ajax.php", { action: "getProfiles", ip: ip }, function(data){
            var tbody = $("#profilesTable tbody");
            tbody.empty();
            if(data.length === 0) {
                tbody.append("<tr><td colspan='6' class='text-center'>No profiles found</td></tr>");
            } else {
                data.forEach(function(profile) {
                    var ports = "";
                    if(profile.minDstPort && profile.maxDstPort) {
                        if(profile.minDstPort == profile.maxDstPort) {
                            ports = profile.minDstPort;
                        } else {
                            ports = profile.minDstPort + " - " + profile.maxDstPort;
                        }
                    }

                    var row = $("<tr></tr>");
                    row.append($("<td></td>").text(ports));
                    row.append($("<td></td>").text(profile.protocol));
                    row.append($("<td></td>").text(profile.preset.action));
                    row.append($("<td></td>").text(profile.preset.name));
                    row.append($("<td></td>").text(profile.notes || ""));
                    var optionsTd = $("<td></td>");
                    var editBtn = $("<button type='button' class='btn btn-sm btn-info mr-1'>Edit</button>");
                    editBtn.click(function(){
                        openProfileModal(profile);
                    });
                    var deleteBtn = $("<button type='button' class='btn btn-sm btn-danger'>Delete</button>");
                    deleteBtn.click(function(){
                        if(confirm("Are you sure you want to delete this profile?")) {
                            deleteProfile(profile.id);
                        }
                    });
                    //optionsTd.append(editBtn).append(deleteBtn);
                    optionsTd.append(deleteBtn);
                    row.append(optionsTd);
                    tbody.append(row);
                });
            }
        });
    }

    function openProfileModal(profile) {
        if(profile) {
            currentProfile = profile;
            $("#profileModalLabel").text("Edit Profile");
            $("#profileId").val(profile.id);
            $("#protocolSelect").val(profile.protocol);

            if(profile.protocol === "ICMP"){
                $("#destinationPortContainer").hide();
                $("#presetContainer").show();
            } else {
                $("#destinationPortContainer, #presetContainer").show();
            }

            if(profile.minDstPort && profile.maxDstPort && profile.minDstPort === profile.maxDstPort) {
                $("#dstPortType").val("individual");
                $("#individualPortContainer").show();
                $("#rangePortContainer").hide();
                $("#dstPort").val(profile.minDstPort);
            } else {
                $("#dstPortType").val("range");
                $("#individualPortContainer").hide();
                $("#rangePortContainer").show();
                $("#minDstPort").val(profile.minDstPort || "");
                $("#maxDstPort").val(profile.maxDstPort || "");
            }

            $("#presetSelect").val(profile.id || "");
            $("#profileNotes").val(profile.notes || "");
        } else {
            currentProfile = null;
            $("#profileModalLabel").text("Create Profile");
            $("#profileForm")[0].reset();
            $("#profileId").val("");
            $("#destinationPortContainer, #presetContainer").show();
            // Por defecto, seleccionar Individual Port
            $("#dstPortType").val("individual");
            $("#individualPortContainer").show();
            $("#rangePortContainer").hide();
        }
        loadPresets();
        $("#profileModal").modal("show");
    }

    $("#protocolSelect").change(function(){
        var protocol = $(this).val();
        if(protocol === "ICMP"){
            $("#destinationPortContainer").hide();
            $("#presetContainer").show();
        } else {
            $("#destinationPortContainer, #presetContainer").show();
            $("#dstPortType").val("individual");
            $("#individualPortContainer").show();
            $("#rangePortContainer").hide();
        }
        loadPresets();
    });

    $("#dstPortType").change(function(){
        var type = $(this).val();
        if(type === "range"){
            $("#individualPortContainer").hide();
            $("#rangePortContainer").show();
        } else {
            $("#rangePortContainer").hide();
            $("#individualPortContainer").show();
        }
    });

    $("#profileForm").submit(function(e){
        e.preventDefault();
        var ip = getSelectedIp();
        var protocol = $("#protocolSelect").val();
        var payload = {
            protocol: protocol,
            presetId: $("#presetSelect").val(),
            notes: $("#profileNotes").val()
        };

        if(protocol !== "ICMP"){
            var portType = $("#dstPortType").val();
            if(portType === "individual"){
                var port = $("#dstPort").val();
                payload.minDstPort = port;
                payload.maxDstPort = port;
            } else {
                payload.minDstPort = $("#minDstPort").val();
                payload.maxDstPort = $("#maxDstPort").val();
            }
        }

        if(currentProfile){
            $.ajax({
                url: "/modules/addons/neoprotect_module/ajax.php",
                method: "PUT",
                data: {
                    action: "updateProfile",
                    profileId: $("#profileId").val(),
                    ip: ip,
                    data: JSON.stringify(payload)
                },
                success: function(response){
                    if(response && response.success){
                        toastr.success("Profile updated successfully");
                        $("#profileModal").modal("hide");
                        loadProfiles();
                    } else {
                        toastr.error("Failed to update profile");
                    }
                }
            });
        } else {
            $.post("/modules/addons/neoprotect_module/ajax.php", {
                action: "createProfile",
                ip: ip,
                data: JSON.stringify(payload)
            }, function(response){
                if(response && response.createdAt){
                    toastr.success("Profile created successfully");
                    $("#profileModal").modal("hide");
                    loadProfiles();
                } else {
                    toastr.error("Failed to create profile");
                }
            });
        }
    });

    function deleteProfile(profileId) {
        var ip = getSelectedIp();
        $.ajax({
            url: "/modules/addons/neoprotect_module/ajax.php",
            method: "POST",
            data: {
                action: "deleteProfile",
                ip: ip,
                profileId: profileId
            }});

        loadProfiles();
        toastr.success("Profile deleted successfully");
    }

    $("#createProfileBtn").click(function(){
        openProfileModal(null);
    });

    function getAvailableCountries() {
        var ip = getSelectedIp();
        $.get("/modules/addons/neoprotect_module/ajax.php", { ip: ip, action: "getCountries" }, function(data){
            availableCountries = data;
            populateCountrySelect();
        });
    }

    function populateCountrySelect() {
        var select = $("#countrySelect");
        select.empty();
        select.append("<option value=''>Select a country</option>");
        availableCountries.forEach(function(country) {
            select.append("<option value='" + country.code + "'>" + country.name + " (" + country.code + ")</option>");
        });
    }

    function updateCountryTable() {
        var tbody = $("#countryListTable tbody");
        tbody.empty();
        selectedCountryList.forEach(function(code, index) {
            var country = availableCountries.find(function(c) { return c.code === code; });
            var name = country ? country.name : code;
            var row = $("<tr></tr>");
            row.append($("<td></td>").text(name + " (" + code + ")"));
            var delBtn = $("<button type='button' class='btn btn-danger btn-sm'>Delete</button>");
            delBtn.click(function(){
                selectedCountryList.splice(index, 1);
                updateCountryTable();
            });
            row.append($("<td></td>").append(delBtn));
            tbody.append(row);
        });
    }


    function updateAsnTable() {
        var tbody = $("#asnListTable tbody");
        tbody.empty();
        asnList.forEach(function(asn, index) {
            var row = $("<tr></tr>");
            row.append($("<td></td>").text(asn));
            var delBtn = $("<button type='button' class='btn btn-danger btn-sm'>Delete</button>");
            delBtn.click(function() {
                asnList.splice(index, 1);
                updateAsnTable();
            });
            row.append($("<td></td>").append(delBtn));
            tbody.append(row);
        });
    }

    $("#addCountryBtn").click(function(){
        var code = $("#countrySelect").val();
        if(code && selectedCountryList.indexOf(code) === -1) {
            selectedCountryList.push(code);
            updateCountryTable();
        } else {
            toastr.warning("Country already added or not selected");
        }
    });

    $("#addAsnBtn").click(function(){
        var asn = $("#asnInput").val();
        if(asn) {
            var asnNum = parseInt(asn);
            if(asnList.indexOf(asnNum) === -1) {
                asnList.push(asnNum);
                updateAsnTable();
                $("#asnInput").val("");
            } else {
                toastr.warning("ASN already added");
            }
        }
    });

    $("#saveAsnFiltering").click(function(e) {
        e.preventDefault();
        var ip = getSelectedIp();
        var data = {
            "asnBlockMode": $("#asnBlockMode").val(),
            "asnBlockList": asnList,
            "countryBlockMode": $("#countryBlockMode").val(),
            "countryBlockList": selectedCountryList
        };

        $.post("/modules/addons/neoprotect_module/ajax.php", {
            action: "saveAsnFiltering",
            ip: ip,
            data: JSON.stringify(data)
        }, function(response) {
            if(response && response.success) {
                toastr.success("Filtering saved successfully");
            } else {
                toastr.error("Failed to save filtering");
            }
        });
    });

    $("#saveDefaultAction").click(function(e) {
        e.preventDefault();
        var ip = getSelectedIp();

        var defaultAction = $("#defaultAction").val();

        $.post("/modules/addons/neoprotect_module/ajax.php", {
            action: "saveDefaultAction",
            ip: ip,
            defaultAction: defaultAction
        });

        toastr.success("Default action saved successfully");
    });

    function getInfo() {
        const ip = getSelectedIp();

        $.post("/modules/addons/neoprotect_module/ajax.php", {
            action: "getInfo",
            ip
        } , function(data) {
            const settings = data.settings;

            const ingress = settings.ingress;
            const egress = settings.egress;
            const icmpLimit = settings.icmpLimit;
            const disabled = settings.disabled;
            const udpStrict = settings.udpStrict;
            const udpFilterThreshold = settings.udpFilterThreshold;
            const synFilterThreshold = settings.synFilterThreshold;
            const ackFilterThreshold = settings.ackFilterThreshold;
            const tmpBlacklistDuration = settings.tmpBlacklistDuration;
            const udpLengthBytesLimit = settings.udpLengthBytesLimit;
            const firstFragmentThreshold = settings.firstFragmentThreshold;
            const symmetricalThreshold = settings.symmetricThreshold;
            const whitelisted = settings.whitelisted;
            const symmetrical = settings.symmetrical;
            const symmetricalBasic = settings.symmetricalBasic;
            const reverseDns = settings.reverseDns;
            const autoMitigation = settings.autoMitigation;
            const tmpBlacklistSyns = settings.tmpBlacklistSyns;
            const tmpBlacklistBytes = settings.tmpBlacklistBytes;
            const allowEgress = settings.allowEgress;
            const countryBlockMode = settings.countryBlockMode;
            const countryBlockList = settings.countryBlockList || [];
            const asnBlockMode = settings.asnBlockMode;
            const asnBlockList = settings.asnBlockList || [];
            const attackDuration = settings.attackDuration;
            const localMinPort = settings.localMinPort;
            const localMaxPort = settings.localMaxPort;
            const tcpConnLimit = settings.tcpConnLimit;
            const tcpConnBytesLimit = settings.tcpConnBytesLimit;
            const udpConnLimit = settings.udpConnLimit;
            const udpConnBytesLimit = settings.udpConnBytesLimit;
            const udpNewConnLimit = settings.udpNewConnLimit;
            const fragmentThreshold = settings.fragmentThreshold;
            const ampThreshold = settings.ampThreshold;
            const udpThreshold = settings.udpThreshold;
            const ackThreshold = settings.ackThreshold;
            const syncStates = settings.syncStates;
            const dropSameSubnet = settings.dropSameSubnet;
            const sampleRate = settings.sampleRate;
            const tmpBlacklist = settings.tmpBlacklist;
            const synThreshold = settings.synThreshold;
            const defaultAction = settings.defaultAction;
            const tunnel = settings.tunnel;
            const ackCheck = settings.ackCheck;
            const synLimit = settings.synLimit;
            const cache = settings.cache;


            $("#defaultAction").val(defaultAction);

            $("#asnBlockMode").val(asnBlockMode);

            if(asnBlockMode === "1" || asnBlockMode === "2" || asnBlockMode === 1 || asnBlockMode === 2) {
                $("#asnFilteringContainer").show();

                asnList = asnBlockList.map(Number);
                updateAsnTable();
            } else {
                $("#asnFilteringContainer").hide();
                asnList = [];
                updateAsnTable();
            }

            $("#countryBlockMode").val(countryBlockMode);
            if(countryBlockMode === "1" || countryBlockMode === "2" || countryBlockMode === 1 || countryBlockMode === 2) {
                $("#countryFilteringContainer").show();
                selectedCountryList = countryBlockList.map(String);
                updateCountryTable();
            } else {
                $("#countryFilteringContainer").hide();
                selectedCountryList = [];
                updateCountryTable();
            }

            $("#attackDuration").val(attackDuration);

            if (allowEgress) {
                $("#allowEgress").prop("checked", true);
            }

            if (ackCheck) {
                $("#ackCheck").prop("checked", true);
            }

            if (symmetrical) {
                $("#symmetricFiltering").prop("checked", true);
            }

            if (symmetrical) {
                $("#symmetricFiltering").prop("checked", true);
                $("#basicSymmetricContainer").show();
            } else {
                $("#symmetricFiltering").prop("checked", false);
                $("#basicSymmetricContainer").hide();
            }

            if (symmetricalBasic) {
                $("#symmetricFiltering2").prop("checked", true);
            }

            $("#synThreshold").val(synThreshold);
            $("#ackThreshold").val(ackThreshold);
            $("#firstFragmentThreshold").val(firstFragmentThreshold);
            $("#fragmentThreshold").val(fragmentThreshold);
            $("#ampThreshold").val(ampThreshold);
            $("#udpThreshold").val(udpThreshold);
            $("#symmetricThreshold").val(symmetricalThreshold);

            $("#tcpConnLimit").val(tcpConnLimit);
            $("#tcpConnBytesLimit").val(tcpConnBytesLimit);
            $("#udpConnLimit").val(udpConnLimit);
            $("#udpConnBytesLimit").val(udpConnBytesLimit);
            $("#udpNewConnLimit").val(udpNewConnLimit);
            $("#synLimit").val(synLimit);
            $("#icmpLimit").val(icmpLimit);
            $("#udpLengthBytesLimit").val(udpLengthBytesLimit);



        });
    }

    function formatDate(dateStr) {
        if (!dateStr) return "";
        return dateStr.substring(0, 19).replace("T", " ");
    }

    function decodeBase64(str){try{return JSON.parse(atob(str));}catch{return{}}}
    function topEntries(obj,n){return Object.entries(obj).sort((a,b)=>b[1]-a[1]).slice(0,n);}

    const dataFields = [
        { key: 'sourceIps', label: 'Top Source IPs' },
        { key: 'protocols', label: 'Top Protocols' },
        { key: 'ttls', label: 'Top TTLs' },
        { key: 'sourceAsns', label: 'Top Source ASNs' },
        { key: 'sourcePorts', label: 'Top Source Ports' },
        { key: 'destinationPorts', label: 'Top Destination Ports' }
    ];

    function renderInfoRow(id, info) {
        let html = `<tr class="attack-info" data-id="${id}"><td colspan="8"><div class="attack-details"><h5>Attack Details</h5>`;
        // Map first, full width
        html += `<div class="row"><div class="col-12" id="map-countries-${id}" style="width:100%;height:300px;margin:10px 0;"></div></div>`;
        // Top Countries chart centered
        html += `<div class="row"><div class="col-lg-6 offset-lg-3 chart-container"><canvas id="chart-countries-${id}"></canvas></div></div>`;
        // Other charts in two columns
        html += `<div class="row">`;
        dataFields.forEach(f => {
            // skip countries field here
            html += `<div class="col-lg-6 chart-container"><canvas id="chart-${f.key}-${id}"></canvas></div>`;
        });
        html += `</div></div></td></tr>`;
        return html;
    }

    function initCharts(id, info) {
        // Top Countries bar chart
        const countries = decodeBase64(info.sourceCountries || '');
        const countryEntries = topEntries(countries);
        const countryLabels = countryEntries.map(e => e[0]);
        const countryValues = countryEntries.map(e => e[1]);
        const ctxCountries = document.getElementById(`chart-countries-${id}`);
        if (ctxCountries) {
            new Chart(ctxCountries, {
                type: 'bar',
                data: { labels: countryLabels, datasets: [{ label: 'Top Countries', data: countryValues }] },
                options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero: true } } }
            });
        }
        // GeoChart map
        google.charts.load('current', { packages: ['geochart'] });
        google.charts.setOnLoadCallback(() => {
            const dataArray = [['Country', 'Attacks']];
            countryEntries.forEach(([code, count]) => dataArray.push([code, count]));
            const dataTable = google.visualization.arrayToDataTable(dataArray);
            const optionsMap = {
                colorAxis: { colors: ['#FFEDA0', '#F03B20'] },
                backgroundColor: { fill: '#ffffff' },
                datalessRegionColor: '#e4e4e4',
                defaultColor: '#e4e4e4'
            };
            const geoChart = new google.visualization.GeoChart(
                document.getElementById(`map-countries-${id}`)
            );
            geoChart.draw(dataTable, optionsMap);
        });
        // Other charts
        dataFields.forEach(f => {
            const dataObj = decodeBase64(info[f.key] || '');
            const entries = topEntries(dataObj);
            const labels = entries.map(e => e[0]);
            const values = entries.map(e => e[1]);
            const cid = `chart-${f.key}-${id}`;
            const ctx = document.getElementById(cid);
            if (ctx) {
                const config = {
                    type: 'bar',
                    data: { labels, datasets: [{ label: f.label, data: values }] },
                    options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero: true } } }
                };
                // Horizontal for Source IPs
                if (f.key === 'sourceIps') {
                    config.options.indexAxis = 'y';
                }
                new Chart(ctx, config);
            }
        });
    }

    function fetchAttackInfo(id, row) {
        const ip = getSelectedIp();

        $.post('/modules/addons/neoprotect_module/ajax.php', { action: 'getAttackInfo', id, ip })
            .done(data => {
                // Remove existing info
                $(`.attack-info[data-id='${id}']`).remove();
                // Insert info row
                row.after(renderInfoRow(id, data));
                // Initialize charts
                initCharts(id, data);
            })
            .fail(() => toastr.error('Error fetching details'));
    }

    function getAttacks() {
        const ip = getSelectedIp();
        $('#attackLoadingIndicator').show();
        $.post('/modules/addons/neoprotect_module/ajax.php', { action: 'getAttacks', ip })
            .done(attacks => {
                const tbody = $('#attackHistoryTable tbody').empty();
                if (!attacks || attacks.length===0) {
                    tbody.append('<tr><td colspan="8" class="text-center">No attacks found</td></tr>');
                } else {
                    attacks.forEach(att => att.signatures.forEach(sig => {
                        const row = $('<tr></tr>');
                        const pic = (sig.bpsPeak*8/1e9).toFixed(2) < 1
                            ? `${(sig.bpsPeak*8/1e6).toFixed(2)} Mbps`
                            : `${(sig.bpsPeak*8/1e9).toFixed(2)} Gbps`;
                        row.append(`<td>${att.dstAddressString||''}</td>`)
                            .append(`<td>${sig.endedAt?'<i class="fas fa-check"></i> Mitigated':'<i class="fas fa-spinner fa-spin"></i> Mitigating'}</td>`)
                            .append(`<td>${sig.name||''}</td>`)
                            .append(`<td>${formatDate(sig.startedAt)}</td>`)
                            .append(`<td>${formatDate(sig.endedAt)}</td>`)
                            .append(`<td>${Number(sig.ppsPeak).toLocaleString('en-US')}</td>`)
                            .append(`<td>${pic}</td>`);
                        const infoTd = $('<td><i class="fas fa-info-circle" style="cursor:pointer;" title="View Details"></i></td>');
                        infoTd.find('i').click(()=>fetchAttackInfo(att.id, row));
                        row.append(infoTd);
                        tbody.append(row);
                    }));
                }
            })
            .always(()=>$('#attackLoadingIndicator').hide());
    }

    function saveSettings() {
        const ip = getSelectedIp();

        const attackDuration = $("#attackDuration").val();
        const allowEgress = $("#allowEgress").prop("checked");
        const ackCheck = $("#ackCheck").prop("checked");
        const symmetrical = $("#symmetricFiltering").prop("checked");
        const symmetricalBasic = $("#symmetricFiltering2").prop("checked");
        const synThreshold = $("#synThreshold").val();
        const ackThreshold = $("#ackThreshold").val();
        const firstFragmentThreshold = $("#firstFragmentThreshold").val();
        const fragmentThreshold = $("#fragmentThreshold").val();
        const ampThreshold = $("#ampThreshold").val();
        const udpThreshold = $("#udpThreshold").val();
        const symmetricalThreshold = $("#symmetricThreshold").val();
        const tcpConnLimit = $("#tcpConnLimit").val();
        const tcpConnBytesLimit = $("#tcpConnBytesLimit").val();
        const udpConnLimit = $("#udpConnLimit").val();
        const udpConnBytesLimit = $("#udpConnBytesLimit").val();
        const udpNewConnLimit = $("#udpNewConnLimit").val();
        const synLimit = $("#synLimit").val();
        const icmpLimit = $("#icmpLimit").val();
        const udpLengthBytesLimit = $("#udpLengthBytesLimit").val();

        if (!symmetrical) {
            const symmetricalBasic = false;
        }

        $.post("/modules/addons/neoprotect_module/ajax.php", {
            action: "saveSettings",
            ip,
            attackDuration,
            allowEgress,
            ackCheck,
            symmetrical,
            symmetricalBasic,
            synThreshold,
            ackThreshold,
            firstFragmentThreshold,
            fragmentThreshold,
            ampThreshold,
            udpThreshold,
            symmetricalThreshold,
            tcpConnLimit,
            tcpConnBytesLimit,
            udpConnLimit,
            udpConnBytesLimit,
            udpNewConnLimit,
            synLimit,
            icmpLimit,
            udpLengthBytesLimit
        });

        toastr.success("Settings saved successfully");
    }

    $(document).on("change", "#symmetricFiltering", function() {
        if ($(this).prop("checked")) {
            $("#basicSymmetricContainer").show();
        } else {
            $("#basicSymmetricContainer").hide();
            $("#symmetricFiltering2").prop("checked", false);
        }
    });

    $(document).ready(function() {
        loadProfiles();
        getAttacks();
        getInfo();
        getAvailableCountries();
        setInterval(getAttacks, 60000);
    });

    $(".saveSettingsBtn").click(function(e) {
        e.preventDefault();
        saveSettings();
    });

    $("#asnBlockMode").change(function(){
        const mode = $(this).val();
        if(mode === "1" || mode === "2") {
            $("#asnFilteringContainer").show();
        } else {
            $("#asnFilteringContainer").hide();
            asnList = [];
            updateAsnTable();
        }
    });

    $("#countryBlockMode").change(function(){
        var mode = $(this).val();
        if(mode === "1" || mode === "2") {
            $("#countryFilteringContainer").show();
        } else {
            $("#countryFilteringContainer").hide();
            selectedCountryList = [];
            updateCountryTable();
        }
    });

    {/literal}
</script>
