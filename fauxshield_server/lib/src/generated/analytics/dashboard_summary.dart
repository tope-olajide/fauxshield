/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:fauxshield_server/src/generated/protocol.dart' as _ipgzzizd;
import 'package:serverpod/serverpod.dart' as _is;
import '../analytics/country_stat.dart' as _ip27a1ot;
import '../analytics/outcome_breakdown.dart' as _ix8xnywr;
import '../analytics/trend_point.dart' as _ici3rjp8;
import '../verification/fraud_alert.dart' as _iwg48j9o;

/// Aggregated dashboard payload powering the operator command center.
abstract class DashboardSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DashboardSummary._({
    required this.windowDays,
    required this.totalVerifications,
    required this.authentic,
    required this.alreadyVerified,
    required this.invalidPin,
    required this.fraudSuspected,
    required this.highRisk,
    required this.recalled,
    required this.openAlerts,
    required this.criticalAlerts,
    required this.identitiesTotal,
    required this.identitiesLocked,
    required this.identitiesRecalled,
    required this.batchesTotal,
    required this.productsTotal,
    required this.trend,
    required this.topCountries,
    required this.outcomes,
    required this.recentAlerts,
    required this.generatedAt,
  });

  factory DashboardSummary({
    required int windowDays,
    required int totalVerifications,
    required int authentic,
    required int alreadyVerified,
    required int invalidPin,
    required int fraudSuspected,
    required int highRisk,
    required int recalled,
    required int openAlerts,
    required int criticalAlerts,
    required int identitiesTotal,
    required int identitiesLocked,
    required int identitiesRecalled,
    required int batchesTotal,
    required int productsTotal,
    required List<_ici3rjp8.TrendPoint> trend,
    required List<_ip27a1ot.CountryStat> topCountries,
    required List<_ix8xnywr.OutcomeBreakdown> outcomes,
    required List<_iwg48j9o.FraudAlert> recentAlerts,
    required DateTime generatedAt,
  }) = _DashboardSummaryImpl;

  factory DashboardSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return DashboardSummary(
      windowDays: jsonSerialization['windowDays'] as int,
      totalVerifications: jsonSerialization['totalVerifications'] as int,
      authentic: jsonSerialization['authentic'] as int,
      alreadyVerified: jsonSerialization['alreadyVerified'] as int,
      invalidPin: jsonSerialization['invalidPin'] as int,
      fraudSuspected: jsonSerialization['fraudSuspected'] as int,
      highRisk: jsonSerialization['highRisk'] as int,
      recalled: jsonSerialization['recalled'] as int,
      openAlerts: jsonSerialization['openAlerts'] as int,
      criticalAlerts: jsonSerialization['criticalAlerts'] as int,
      identitiesTotal: jsonSerialization['identitiesTotal'] as int,
      identitiesLocked: jsonSerialization['identitiesLocked'] as int,
      identitiesRecalled: jsonSerialization['identitiesRecalled'] as int,
      batchesTotal: jsonSerialization['batchesTotal'] as int,
      productsTotal: jsonSerialization['productsTotal'] as int,
      trend: _ipgzzizd.Protocol().deserialize<List<_ici3rjp8.TrendPoint>>(
        jsonSerialization['trend'],
      ),
      topCountries: _ipgzzizd.Protocol()
          .deserialize<List<_ip27a1ot.CountryStat>>(
            jsonSerialization['topCountries'],
          ),
      outcomes: _ipgzzizd.Protocol()
          .deserialize<List<_ix8xnywr.OutcomeBreakdown>>(
            jsonSerialization['outcomes'],
          ),
      recentAlerts: _ipgzzizd.Protocol()
          .deserialize<List<_iwg48j9o.FraudAlert>>(
            jsonSerialization['recentAlerts'],
          ),
      generatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
    );
  }

  int windowDays;

  int totalVerifications;

  int authentic;

  int alreadyVerified;

  int invalidPin;

  int fraudSuspected;

  int highRisk;

  int recalled;

  int openAlerts;

  int criticalAlerts;

  int identitiesTotal;

  int identitiesLocked;

  int identitiesRecalled;

  int batchesTotal;

  int productsTotal;

  List<_ici3rjp8.TrendPoint> trend;

  List<_ip27a1ot.CountryStat> topCountries;

  List<_ix8xnywr.OutcomeBreakdown> outcomes;

  List<_iwg48j9o.FraudAlert> recentAlerts;

  DateTime generatedAt;

  /// Returns a shallow copy of this [DashboardSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DashboardSummary copyWith({
    int? windowDays,
    int? totalVerifications,
    int? authentic,
    int? alreadyVerified,
    int? invalidPin,
    int? fraudSuspected,
    int? highRisk,
    int? recalled,
    int? openAlerts,
    int? criticalAlerts,
    int? identitiesTotal,
    int? identitiesLocked,
    int? identitiesRecalled,
    int? batchesTotal,
    int? productsTotal,
    List<_ici3rjp8.TrendPoint>? trend,
    List<_ip27a1ot.CountryStat>? topCountries,
    List<_ix8xnywr.OutcomeBreakdown>? outcomes,
    List<_iwg48j9o.FraudAlert>? recentAlerts,
    DateTime? generatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DashboardSummary',
      'windowDays': windowDays,
      'totalVerifications': totalVerifications,
      'authentic': authentic,
      'alreadyVerified': alreadyVerified,
      'invalidPin': invalidPin,
      'fraudSuspected': fraudSuspected,
      'highRisk': highRisk,
      'recalled': recalled,
      'openAlerts': openAlerts,
      'criticalAlerts': criticalAlerts,
      'identitiesTotal': identitiesTotal,
      'identitiesLocked': identitiesLocked,
      'identitiesRecalled': identitiesRecalled,
      'batchesTotal': batchesTotal,
      'productsTotal': productsTotal,
      'trend': trend.toJson(valueToJson: (v) => v.toJson()),
      'topCountries': topCountries.toJson(valueToJson: (v) => v.toJson()),
      'outcomes': outcomes.toJson(valueToJson: (v) => v.toJson()),
      'recentAlerts': recentAlerts.toJson(valueToJson: (v) => v.toJson()),
      'generatedAt': generatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DashboardSummary',
      'windowDays': windowDays,
      'totalVerifications': totalVerifications,
      'authentic': authentic,
      'alreadyVerified': alreadyVerified,
      'invalidPin': invalidPin,
      'fraudSuspected': fraudSuspected,
      'highRisk': highRisk,
      'recalled': recalled,
      'openAlerts': openAlerts,
      'criticalAlerts': criticalAlerts,
      'identitiesTotal': identitiesTotal,
      'identitiesLocked': identitiesLocked,
      'identitiesRecalled': identitiesRecalled,
      'batchesTotal': batchesTotal,
      'productsTotal': productsTotal,
      'trend': trend.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'topCountries': topCountries.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'outcomes': outcomes.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'recentAlerts': recentAlerts.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'generatedAt': generatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _DashboardSummaryImpl extends DashboardSummary {
  _DashboardSummaryImpl({
    required int windowDays,
    required int totalVerifications,
    required int authentic,
    required int alreadyVerified,
    required int invalidPin,
    required int fraudSuspected,
    required int highRisk,
    required int recalled,
    required int openAlerts,
    required int criticalAlerts,
    required int identitiesTotal,
    required int identitiesLocked,
    required int identitiesRecalled,
    required int batchesTotal,
    required int productsTotal,
    required List<_ici3rjp8.TrendPoint> trend,
    required List<_ip27a1ot.CountryStat> topCountries,
    required List<_ix8xnywr.OutcomeBreakdown> outcomes,
    required List<_iwg48j9o.FraudAlert> recentAlerts,
    required DateTime generatedAt,
  }) : super._(
         windowDays: windowDays,
         totalVerifications: totalVerifications,
         authentic: authentic,
         alreadyVerified: alreadyVerified,
         invalidPin: invalidPin,
         fraudSuspected: fraudSuspected,
         highRisk: highRisk,
         recalled: recalled,
         openAlerts: openAlerts,
         criticalAlerts: criticalAlerts,
         identitiesTotal: identitiesTotal,
         identitiesLocked: identitiesLocked,
         identitiesRecalled: identitiesRecalled,
         batchesTotal: batchesTotal,
         productsTotal: productsTotal,
         trend: trend,
         topCountries: topCountries,
         outcomes: outcomes,
         recentAlerts: recentAlerts,
         generatedAt: generatedAt,
       );

  /// Returns a shallow copy of this [DashboardSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DashboardSummary copyWith({
    int? windowDays,
    int? totalVerifications,
    int? authentic,
    int? alreadyVerified,
    int? invalidPin,
    int? fraudSuspected,
    int? highRisk,
    int? recalled,
    int? openAlerts,
    int? criticalAlerts,
    int? identitiesTotal,
    int? identitiesLocked,
    int? identitiesRecalled,
    int? batchesTotal,
    int? productsTotal,
    List<_ici3rjp8.TrendPoint>? trend,
    List<_ip27a1ot.CountryStat>? topCountries,
    List<_ix8xnywr.OutcomeBreakdown>? outcomes,
    List<_iwg48j9o.FraudAlert>? recentAlerts,
    DateTime? generatedAt,
  }) {
    return DashboardSummary(
      windowDays: windowDays ?? this.windowDays,
      totalVerifications: totalVerifications ?? this.totalVerifications,
      authentic: authentic ?? this.authentic,
      alreadyVerified: alreadyVerified ?? this.alreadyVerified,
      invalidPin: invalidPin ?? this.invalidPin,
      fraudSuspected: fraudSuspected ?? this.fraudSuspected,
      highRisk: highRisk ?? this.highRisk,
      recalled: recalled ?? this.recalled,
      openAlerts: openAlerts ?? this.openAlerts,
      criticalAlerts: criticalAlerts ?? this.criticalAlerts,
      identitiesTotal: identitiesTotal ?? this.identitiesTotal,
      identitiesLocked: identitiesLocked ?? this.identitiesLocked,
      identitiesRecalled: identitiesRecalled ?? this.identitiesRecalled,
      batchesTotal: batchesTotal ?? this.batchesTotal,
      productsTotal: productsTotal ?? this.productsTotal,
      trend: trend ?? this.trend.map((e0) => e0.copyWith()).toList(),
      topCountries:
          topCountries ?? this.topCountries.map((e0) => e0.copyWith()).toList(),
      outcomes: outcomes ?? this.outcomes.map((e0) => e0.copyWith()).toList(),
      recentAlerts:
          recentAlerts ?? this.recentAlerts.map((e0) => e0.copyWith()).toList(),
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }
}
