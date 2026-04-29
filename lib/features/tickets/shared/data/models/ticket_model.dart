import '../../domain/entities/ticket.dart';

/// API / persistence DTO layer (same naming as attendance `*_model.dart`).
///
/// Offline mock uses [Ticket] entities directly via [Ticket.fromMap] / [toMap].
class TicketModel {
  TicketModel._();

  /// Parse wire JSON into a domain [Ticket].
  static Ticket fromJson(Map<String, dynamic> json) => Ticket.fromMap(json);

  /// Serialize domain ticket for APIs.
  static Map<String, dynamic> toJson(Ticket ticket) => ticket.toMap();
}
