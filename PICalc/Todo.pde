/*
- Save History

- Polish Flow damping
  - Do not damp movement due to magnitude shifting

- Update consolidated nodes' magnitude to fit to min( input, output )?

- Some issues with null flows, especially with multiple in-between the same nodes (except for market)

- Market nodes don't work well with flows when backwards (negative values on right)

- Market nodes should sort horizontally

- Consider nodes to handle market expenses
  - Processes with >1 output? OHSHIT

- Think very carefully how to draw log graphs
  - Probably will need to shift more code into graph axes

- Allow graphs to zoom to values

- Flow should use 2 arrays: tSourceVertices[2] and tTargetVertices[2] instead of tFlowVertices[4]

*/
