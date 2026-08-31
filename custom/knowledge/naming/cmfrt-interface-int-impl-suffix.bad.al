// Anti-pattern: the I-prefix. It lands between the mandatory CMFRT AM prefix
// and the descriptive name, so the reader parses three markers before the verb,
// and the interface sorts under "I" instead of next to its implementation.
// Correct: "CMFRT AM FindOverlapInt"
interface "CMFRT AM IFind Overlap"
{
    procedure CMFRTAMFindOverlap(AddressNo: Code[20]; FromDate: Date; ToDate: Date): Boolean
}

// Anti-pattern: the implementation carries no suffix at all. Nothing in this
// name says it is the default implementation of anything, and nothing in the
// interface's name points here.
// Correct: "CMFRT AM FindOverlapImpl"
codeunit 2045100 "CMFRT AM Find Overlap" implements "CMFRT AM IFind Overlap"
{
    procedure CMFRTAMFindOverlap(AddressNo: Code[20]; FromDate: Date; ToDate: Date): Boolean
    begin
    end;
}

// Anti-pattern: dotted ad-hoc contractions in an object name. They have no
// precedent in the house repos, they leak into the file name
// (CMFRTAMIGetCur.Desig..Interface.al), and the I-prefix is still wrong.
// Correct: "CMFRT AM GetCurDesignInt" with "CMFRT AM GetCurDesignImpl"
interface "CMFRT AM IGet Cur.Desig."
{
    procedure CMFRTAMGetCurrentDesignation(AddressNo: Code[20]): Code[20]
}

// Anti-pattern: the descriptive part was planned at the full 21-character
// budget without the suffix, so neither Int nor Impl fits — this name is 36.
// The budget must be counted with the suffix: at most 17 characters shared.
// Correct: "CMFRT AM RelDocCollectInt"
interface "CMFRT AM Related Document CollectInt"
{
    procedure CMFRTAMCollectRelatedDocuments(AddressNo: Code[20]): Integer
}
