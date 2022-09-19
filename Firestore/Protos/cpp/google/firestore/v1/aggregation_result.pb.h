/*
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: google/firestore/v1/aggregation_result.proto

#ifndef GOOGLE_PROTOBUF_INCLUDED_google_2ffirestore_2fv1_2faggregation_5fresult_2eproto
#define GOOGLE_PROTOBUF_INCLUDED_google_2ffirestore_2fv1_2faggregation_5fresult_2eproto

#include <limits>
#include <string>

#include <google/protobuf/port_def.inc>
#if PROTOBUF_VERSION < 3011000
#error This file was generated by a newer version of protoc which is
#error incompatible with your Protocol Buffer headers. Please update
#error your headers.
#endif
#if 3011002 < PROTOBUF_MIN_PROTOC_VERSION
#error This file was generated by an older version of protoc which is
#error incompatible with your Protocol Buffer headers. Please
#error regenerate this file with a newer version of protoc.
#endif

#include <google/protobuf/port_undef.inc>
#include <google/protobuf/io/coded_stream.h>
#include <google/protobuf/arena.h>
#include <google/protobuf/arenastring.h>
#include <google/protobuf/generated_message_table_driven.h>
#include <google/protobuf/generated_message_util.h>
#include <google/protobuf/inlined_string_field.h>
#include <google/protobuf/metadata.h>
#include <google/protobuf/generated_message_reflection.h>
#include <google/protobuf/message.h>
#include <google/protobuf/repeated_field.h>  // IWYU pragma: export
#include <google/protobuf/extension_set.h>  // IWYU pragma: export
#include <google/protobuf/map.h>  // IWYU pragma: export
#include <google/protobuf/map_entry.h>
#include <google/protobuf/map_field_inl.h>
#include <google/protobuf/unknown_field_set.h>
#include "google/firestore/v1/document.pb.h"
// @@protoc_insertion_point(includes)
#include <google/protobuf/port_def.inc>
#define PROTOBUF_INTERNAL_EXPORT_google_2ffirestore_2fv1_2faggregation_5fresult_2eproto
PROTOBUF_NAMESPACE_OPEN
namespace internal {
class AnyMetadata;
}  // namespace internal
PROTOBUF_NAMESPACE_CLOSE

// Internal implementation detail -- do not use these members.
struct TableStruct_google_2ffirestore_2fv1_2faggregation_5fresult_2eproto {
  static const ::PROTOBUF_NAMESPACE_ID::internal::ParseTableField entries[]
    PROTOBUF_SECTION_VARIABLE(protodesc_cold);
  static const ::PROTOBUF_NAMESPACE_ID::internal::AuxillaryParseTableField aux[]
    PROTOBUF_SECTION_VARIABLE(protodesc_cold);
  static const ::PROTOBUF_NAMESPACE_ID::internal::ParseTable schema[2]
    PROTOBUF_SECTION_VARIABLE(protodesc_cold);
  static const ::PROTOBUF_NAMESPACE_ID::internal::FieldMetadata field_metadata[];
  static const ::PROTOBUF_NAMESPACE_ID::internal::SerializationTable serialization_table[];
  static const ::PROTOBUF_NAMESPACE_ID::uint32 offsets[];
};
extern const ::PROTOBUF_NAMESPACE_ID::internal::DescriptorTable descriptor_table_google_2ffirestore_2fv1_2faggregation_5fresult_2eproto;
namespace google {
namespace firestore {
namespace v1 {
class AggregationResult;
class AggregationResultDefaultTypeInternal;
extern AggregationResultDefaultTypeInternal _AggregationResult_default_instance_;
class AggregationResult_AggregateFieldsEntry_DoNotUse;
class AggregationResult_AggregateFieldsEntry_DoNotUseDefaultTypeInternal;
extern AggregationResult_AggregateFieldsEntry_DoNotUseDefaultTypeInternal _AggregationResult_AggregateFieldsEntry_DoNotUse_default_instance_;
}  // namespace v1
}  // namespace firestore
}  // namespace google
PROTOBUF_NAMESPACE_OPEN
template<> ::google::firestore::v1::AggregationResult* Arena::CreateMaybeMessage<::google::firestore::v1::AggregationResult>(Arena*);
template<> ::google::firestore::v1::AggregationResult_AggregateFieldsEntry_DoNotUse* Arena::CreateMaybeMessage<::google::firestore::v1::AggregationResult_AggregateFieldsEntry_DoNotUse>(Arena*);
PROTOBUF_NAMESPACE_CLOSE
namespace google {
namespace firestore {
namespace v1 {

// ===================================================================

class AggregationResult_AggregateFieldsEntry_DoNotUse : public ::PROTOBUF_NAMESPACE_ID::internal::MapEntry<AggregationResult_AggregateFieldsEntry_DoNotUse, 
    std::string, ::google::firestore::v1::Value,
    ::PROTOBUF_NAMESPACE_ID::internal::WireFormatLite::TYPE_STRING,
    ::PROTOBUF_NAMESPACE_ID::internal::WireFormatLite::TYPE_MESSAGE,
    0 > {
public:
  typedef ::PROTOBUF_NAMESPACE_ID::internal::MapEntry<AggregationResult_AggregateFieldsEntry_DoNotUse, 
    std::string, ::google::firestore::v1::Value,
    ::PROTOBUF_NAMESPACE_ID::internal::WireFormatLite::TYPE_STRING,
    ::PROTOBUF_NAMESPACE_ID::internal::WireFormatLite::TYPE_MESSAGE,
    0 > SuperType;
  AggregationResult_AggregateFieldsEntry_DoNotUse();
  AggregationResult_AggregateFieldsEntry_DoNotUse(::PROTOBUF_NAMESPACE_ID::Arena* arena);
  void MergeFrom(const AggregationResult_AggregateFieldsEntry_DoNotUse& other);
  static const AggregationResult_AggregateFieldsEntry_DoNotUse* internal_default_instance() { return reinterpret_cast<const AggregationResult_AggregateFieldsEntry_DoNotUse*>(&_AggregationResult_AggregateFieldsEntry_DoNotUse_default_instance_); }
  static bool ValidateKey(std::string* s) {
    return ::PROTOBUF_NAMESPACE_ID::internal::WireFormatLite::VerifyUtf8String(s->data(), static_cast<int>(s->size()), ::PROTOBUF_NAMESPACE_ID::internal::WireFormatLite::PARSE, "google.firestore.v1.AggregationResult.AggregateFieldsEntry.key");
 }
  static bool ValidateValue(void*) { return true; }
  void MergeFrom(const ::PROTOBUF_NAMESPACE_ID::Message& other) final;
  ::PROTOBUF_NAMESPACE_ID::Metadata GetMetadata() const final;
  private:
  static ::PROTOBUF_NAMESPACE_ID::Metadata GetMetadataStatic() {
    ::PROTOBUF_NAMESPACE_ID::internal::AssignDescriptors(&::descriptor_table_google_2ffirestore_2fv1_2faggregation_5fresult_2eproto);
    return ::descriptor_table_google_2ffirestore_2fv1_2faggregation_5fresult_2eproto.file_level_metadata[0];
  }

  public:
};

// -------------------------------------------------------------------

class AggregationResult :
    public ::PROTOBUF_NAMESPACE_ID::Message /* @@protoc_insertion_point(class_definition:google.firestore.v1.AggregationResult) */ {
 public:
  AggregationResult();
  virtual ~AggregationResult();

  AggregationResult(const AggregationResult& from);
  AggregationResult(AggregationResult&& from) noexcept
    : AggregationResult() {
    *this = ::std::move(from);
  }

  inline AggregationResult& operator=(const AggregationResult& from) {
    CopyFrom(from);
    return *this;
  }
  inline AggregationResult& operator=(AggregationResult&& from) noexcept {
    if (GetArenaNoVirtual() == from.GetArenaNoVirtual()) {
      if (this != &from) InternalSwap(&from);
    } else {
      CopyFrom(from);
    }
    return *this;
  }

  static const ::PROTOBUF_NAMESPACE_ID::Descriptor* descriptor() {
    return GetDescriptor();
  }
  static const ::PROTOBUF_NAMESPACE_ID::Descriptor* GetDescriptor() {
    return GetMetadataStatic().descriptor;
  }
  static const ::PROTOBUF_NAMESPACE_ID::Reflection* GetReflection() {
    return GetMetadataStatic().reflection;
  }
  static const AggregationResult& default_instance();

  static void InitAsDefaultInstance();  // FOR INTERNAL USE ONLY
  static inline const AggregationResult* internal_default_instance() {
    return reinterpret_cast<const AggregationResult*>(
               &_AggregationResult_default_instance_);
  }
  static constexpr int kIndexInFileMessages =
    1;

  friend void swap(AggregationResult& a, AggregationResult& b) {
    a.Swap(&b);
  }
  inline void Swap(AggregationResult* other) {
    if (other == this) return;
    InternalSwap(other);
  }

  // implements Message ----------------------------------------------

  inline AggregationResult* New() const final {
    return CreateMaybeMessage<AggregationResult>(nullptr);
  }

  AggregationResult* New(::PROTOBUF_NAMESPACE_ID::Arena* arena) const final {
    return CreateMaybeMessage<AggregationResult>(arena);
  }
  void CopyFrom(const ::PROTOBUF_NAMESPACE_ID::Message& from) final;
  void MergeFrom(const ::PROTOBUF_NAMESPACE_ID::Message& from) final;
  void CopyFrom(const AggregationResult& from);
  void MergeFrom(const AggregationResult& from);
  PROTOBUF_ATTRIBUTE_REINITIALIZES void Clear() final;
  bool IsInitialized() const final;

  size_t ByteSizeLong() const final;
  const char* _InternalParse(const char* ptr, ::PROTOBUF_NAMESPACE_ID::internal::ParseContext* ctx) final;
  ::PROTOBUF_NAMESPACE_ID::uint8* _InternalSerialize(
      ::PROTOBUF_NAMESPACE_ID::uint8* target, ::PROTOBUF_NAMESPACE_ID::io::EpsCopyOutputStream* stream) const final;
  int GetCachedSize() const final { return _cached_size_.Get(); }

  private:
  inline void SharedCtor();
  inline void SharedDtor();
  void SetCachedSize(int size) const final;
  void InternalSwap(AggregationResult* other);
  friend class ::PROTOBUF_NAMESPACE_ID::internal::AnyMetadata;
  static ::PROTOBUF_NAMESPACE_ID::StringPiece FullMessageName() {
    return "google.firestore.v1.AggregationResult";
  }
  private:
  inline ::PROTOBUF_NAMESPACE_ID::Arena* GetArenaNoVirtual() const {
    return nullptr;
  }
  inline void* MaybeArenaPtr() const {
    return nullptr;
  }
  public:

  ::PROTOBUF_NAMESPACE_ID::Metadata GetMetadata() const final;
  private:
  static ::PROTOBUF_NAMESPACE_ID::Metadata GetMetadataStatic() {
    ::PROTOBUF_NAMESPACE_ID::internal::AssignDescriptors(&::descriptor_table_google_2ffirestore_2fv1_2faggregation_5fresult_2eproto);
    return ::descriptor_table_google_2ffirestore_2fv1_2faggregation_5fresult_2eproto.file_level_metadata[kIndexInFileMessages];
  }

  public:

  // nested types ----------------------------------------------------


  // accessors -------------------------------------------------------

  enum : int {
    kAggregateFieldsFieldNumber = 2,
  };
  // map<string, .google.firestore.v1.Value> aggregate_fields = 2;
  int aggregate_fields_size() const;
  private:
  int _internal_aggregate_fields_size() const;
  public:
  void clear_aggregate_fields();
  private:
  const ::PROTOBUF_NAMESPACE_ID::Map< std::string, ::google::firestore::v1::Value >&
      _internal_aggregate_fields() const;
  ::PROTOBUF_NAMESPACE_ID::Map< std::string, ::google::firestore::v1::Value >*
      _internal_mutable_aggregate_fields();
  public:
  const ::PROTOBUF_NAMESPACE_ID::Map< std::string, ::google::firestore::v1::Value >&
      aggregate_fields() const;
  ::PROTOBUF_NAMESPACE_ID::Map< std::string, ::google::firestore::v1::Value >*
      mutable_aggregate_fields();

  // @@protoc_insertion_point(class_scope:google.firestore.v1.AggregationResult)
 private:
  class _Internal;

  ::PROTOBUF_NAMESPACE_ID::internal::InternalMetadataWithArena _internal_metadata_;
  ::PROTOBUF_NAMESPACE_ID::internal::MapField<
      AggregationResult_AggregateFieldsEntry_DoNotUse,
      std::string, ::google::firestore::v1::Value,
      ::PROTOBUF_NAMESPACE_ID::internal::WireFormatLite::TYPE_STRING,
      ::PROTOBUF_NAMESPACE_ID::internal::WireFormatLite::TYPE_MESSAGE,
      0 > aggregate_fields_;
  mutable ::PROTOBUF_NAMESPACE_ID::internal::CachedSize _cached_size_;
  friend struct ::TableStruct_google_2ffirestore_2fv1_2faggregation_5fresult_2eproto;
};
// ===================================================================


// ===================================================================

#ifdef __GNUC__
  #pragma GCC diagnostic push
  #pragma GCC diagnostic ignored "-Wstrict-aliasing"
#endif  // __GNUC__
// -------------------------------------------------------------------

// AggregationResult

// map<string, .google.firestore.v1.Value> aggregate_fields = 2;
inline int AggregationResult::_internal_aggregate_fields_size() const {
  return aggregate_fields_.size();
}
inline int AggregationResult::aggregate_fields_size() const {
  return _internal_aggregate_fields_size();
}
inline const ::PROTOBUF_NAMESPACE_ID::Map< std::string, ::google::firestore::v1::Value >&
AggregationResult::_internal_aggregate_fields() const {
  return aggregate_fields_.GetMap();
}
inline const ::PROTOBUF_NAMESPACE_ID::Map< std::string, ::google::firestore::v1::Value >&
AggregationResult::aggregate_fields() const {
  // @@protoc_insertion_point(field_map:google.firestore.v1.AggregationResult.aggregate_fields)
  return _internal_aggregate_fields();
}
inline ::PROTOBUF_NAMESPACE_ID::Map< std::string, ::google::firestore::v1::Value >*
AggregationResult::_internal_mutable_aggregate_fields() {
  return aggregate_fields_.MutableMap();
}
inline ::PROTOBUF_NAMESPACE_ID::Map< std::string, ::google::firestore::v1::Value >*
AggregationResult::mutable_aggregate_fields() {
  // @@protoc_insertion_point(field_mutable_map:google.firestore.v1.AggregationResult.aggregate_fields)
  return _internal_mutable_aggregate_fields();
}

#ifdef __GNUC__
  #pragma GCC diagnostic pop
#endif  // __GNUC__
// -------------------------------------------------------------------


// @@protoc_insertion_point(namespace_scope)

}  // namespace v1
}  // namespace firestore
}  // namespace google

// @@protoc_insertion_point(global_scope)

#include <google/protobuf/port_undef.inc>
#endif  // GOOGLE_PROTOBUF_INCLUDED_GOOGLE_PROTOBUF_INCLUDED_google_2ffirestore_2fv1_2faggregation_5fresult_2eproto