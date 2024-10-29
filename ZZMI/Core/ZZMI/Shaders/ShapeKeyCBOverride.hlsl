// Compute shader that takes cb0 as input and finds the corresponding values in the offset buffer, then returns the mod versions of it into cb0
// Inputs:
// CB0: original offset, count, multiplier, unused
// t-100: OffsetB
// Outputs:
// u7: new offset, new count, multiplier, unused
struct offset_t
{
    uint old_offset;
    uint old_count;
    uint new_offset;
    uint new_count;
};
struct cb0_t
{
    uint offset;
    uint count;
    float multiplier;
    uint unused;
};
cbuffer cb0 : register(b0)
{
    cb0_t cb0[1];
};
StructuredBuffer<offset_t> OffsetB : register(t100);
RWBuffer<float4> VirtualCB : register(u7);
RWBuffer<float> MultipliersRW : register(u5);
// RWBuffer<float4> Multiplier : register(u8);
#ifdef COMPUTE_SHADER
[numthreads(1, 1, 1)]
void main(uint3 ThreadId: SV_DispatchThreadID)
{
    // TODO: Add override here
    float4 temp = float4(0, 0, 0, 8);
    uint len = 0;
    uint stride = 0;
    OffsetB.GetDimensions(len, stride);

    for (uint i = 0; i < len; ++i)
    {
        if (cb0[0].offset == OffsetB[i].old_offset && cb0[0].count == OffsetB[i].old_count)
        {
            temp.x = (float)OffsetB[i].new_offset;
            temp.y = (float)OffsetB[i].new_count;
            // temp.z = Multiplier[i];
            MultipliersRW[i] = cb0[0].multiplier;
            temp.z = cb0[0].multiplier;
            temp.w = len;
            break;
        }
    }
    VirtualCB[0] = temp;
}
#endif
