import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'business_info_model.dart';

class BusinessInfoViewModel {
  final SupabaseClient client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchDiscounts(int businessId) async {
    try {
      final response = await client
          .from('descuento')
          .select('*')
          .eq('id_negocio', businessId)
          .eq('state', true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching discounts: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> fetchAddress(int businessId) async {
    try {
      final response = await client
          .from('direccion')
          .select('*')
          .eq('id_negocio', businessId)
          .single();
      return response;
    } catch (e) {
      print('Error fetching address: $e');
      return null;
    }
  }

  Future<Business> fetchBusiness(int businessId) async {
    try {
      final response = await client
          .from('negocio')
          .select('*')
          .eq('id', businessId)
          .single();
      return Business.fromJson(response);
    } catch (e) {
      print('Error fetching business: $e');
      return Business(
        id: 0,
        name: '',
        description: '',
        picture: '',
        tiktok: '',
        instagram: '',
        webpage: '',
      );
    }
  }

  Future<bool> deleteBusiness(int businessId) async {
    try {
      await client.from('negocio').delete().eq('id', businessId);
      return true;
    } catch (e) {
      print('Error deleting business: $e');
      return false;
    }
  }

  Future<int?> addDiscount(Discount discount) async {
    try {
      final response = await client.from('descuento').insert(discount.toJson()).select('id').single();
      return response['id'];
    } catch (e) {
      print('Error adding discount: $e');
      return null;
    }
  }

  Future<int?> updateDiscount(int discountId, Discount discount) async {
    try {
      final response = await client
          .from('descuento')
          .update(discount.toJson())
          .eq('id', discountId)
          .select('id')
          .single();
      return response['id'];
    } catch (e) {
      print('Error updating discount: $e');
      return null;
    }
  }

  Future<bool> deleteDiscount(int discountId) async {
    try {
      await client.from('descuento').delete().eq('id', discountId);
      return true;
    } catch (e) {
      print('Error deleting discount: $e');
      return false;
    }
  }
}