import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:horti_vige/core/exceptions/app_exception.dart';
import 'package:horti_vige/core/utils/helpers/preference_manager.dart';
import 'package:horti_vige/data/database/collection_refs.dart';
import 'package:horti_vige/data/enums/consultation_status.dart';
import 'package:horti_vige/data/models/consultation/consultation_model.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';

class ConsultationRepository {
  ConsultationRepository._();

  static final _consultationsCollectionRef = CollectionRefs.consultations;

  static Future<void> updateConsultationStatus(
    String consultationId,
    ConsultationStatus status,
  ) async {
    try {
      await _consultationsCollectionRef
          .doc(consultationId)
          .update({'status': status.name});
    } on FirebaseException catch (e) {
      throw AppException(
        message: e.message ?? '',
        title: 'Error updating consultation status',
      );
    }
  }

  static Future<void> addConsultationRequest(
    ConsultationModel consultation,
  ) async {
    try {
      await _consultationsCollectionRef
          .doc(consultation.id)
          .set(consultation.toJson());
    } on FirebaseException catch (e) {
      throw AppException(
        message: e.message ?? '',
        title: 'Error adding consultation request',
      );
    }
  }

  static Stream<List<ConsultationModel>>
      getPendingConsultationRequestsBySpecialist() {
    // Get current DateTime
    DateTime now = DateTime.now();

    return _consultationsCollectionRef
        .where(
          FieldPath(const ['specialist', 'id']),
          isEqualTo: PreferenceManager.getInstance().getCurrentUser()!.id,
        )
        .where('status', isEqualTo: ConsultationStatus.pending.name)
        .where('startTime',
            isGreaterThan:
                now.toIso8601String()) // Filter expired consultations
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((querySnapshots) {
      final requests = <ConsultationModel>[];
      for (final DocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshots.docs) {
        requests.add(ConsultationModel.fromJson(doc.data()!));
      }
      for (var req in requests) {
        debugPrint('consultation id: ${req.id}');
      }
      return requests;
    });
  }

  static Future<ConsultationModel?> findConsultationBySpecialistEmail(
    String email,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user!.uid;
      userId.log();
      email.log();
      final snapshot = await _consultationsCollectionRef
          .where(FieldPath(const ['customer', 'id']), isEqualTo: userId)
          .where(
            FieldPath(const ['specialist', 'email']),
            isEqualTo: email,
          )
          // .where(
          //   'startTime',
          //   isGreaterThan: DateTime.now().millisecondsSinceEpoch,
          // )
          .get();

      if (snapshot.docs.isNotEmpty) {
        final consultations = snapshot.docs
            .map((e) => ConsultationModel.fromJson(e.data()))
            .toList();
        final sortedConsultations = consultations
            .where(
              (element) =>
                  element.status != ConsultationStatus.canceled &&
                  element.status != ConsultationStatus.rejected,
            )
            .toList();
        sortedConsultations.sort((a, b) => a.startTime.compareTo(b.startTime));
        if (sortedConsultations.isNotEmpty) {
          return sortedConsultations.first;
        } else {
          return null;
        }
      }
      return null;
    } on FirebaseException catch (e) {
      throw AppException(
        title: 'Getting consultation data failed',
        message: e.message ?? 'Something went wrong',
      );
    } catch (e) {
      throw AppException(
        title: 'Getting consultation data failed',
        message: e.toString(),
      );
    }
  }
}
