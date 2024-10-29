// struct u0_t
// {
//     float3 pos;
//     float3 norm;
//     float4 tang;
// };
// struct offset_t
// {
//     uint old_offset;
//     uint old_count;
//     uint new_offset;
//     uint new_count;
// };
struct shapekey_t
{
    uint idx;
    float3 pos;
    float3 norm;
    float3 tang;
};
RWBuffer<float> DebugRW : register(u1);
RWBuffer<float> u0 : register(u0);
// Vertices
Buffer<float> MultipliersRW : register(t100);
// List of multiplers. 1  x SK
StructuredBuffer<shapekey_t> Shapekeys : register(t101);
// SK data (concatenated slices)
Buffer<uint4> Offsets : register(t102);
// Offset data (old_offset, old_count, new_offset, new_count)

[numthreads(64, 1, 1)]
void main(uint3 ThreadId: SV_DispatchThreadID)
{
    float mult = -1;
    uint len = 0;
    Offsets.GetDimensions(len);
    uint idx = ThreadId.x;
    shapekey_t shapekey = Shapekeys[idx];
    for (uint i = 0; i < len; ++i)
    {
        if (idx >= Offsets[i].z && idx < Offsets[i].z + Offsets[i].w)
        {
            mult = MultipliersRW[i];
            DebugRW[i] = MultipliersRW[i];
            if (mult == 0.0)
                return;
            break;
        }
    }
    u0[shapekey.idx * 10 + 0] += shapekey.pos.x * mult;
    u0[shapekey.idx * 10 + 1] += shapekey.pos.y * mult;
    u0[shapekey.idx * 10 + 2] += shapekey.pos.z * mult;

}
