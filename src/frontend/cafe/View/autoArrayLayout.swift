//
//  autoArrayLayoutView.swift
//  cafe
//
//  Created by 蔡沅恆 on 2024/2/15.
//

import SwiftUI

struct autoArrayLayoutView: Layout {
    let hSpacing: CGFloat = 5
    let vSpacing: CGFloat = 5
    
    struct Row{
        var elementCGRects: [CGRect] = []
        var width: CGFloat {elementCGRects.last?.maxX ?? 0}
        var heigh: CGFloat = 0
    }
    
    func getRow(subviews: Subviews, proposaWidth: CGFloat?) -> [Row]{
        guard let proposaWidth,!subviews.isEmpty else{return []}
        let proposal = ProposedViewSize(width: proposaWidth, height: nil)
        var currentY: CGFloat = vSpacing
        var maxHeight: CGFloat = 0
        
        //find the max hight
        subviews.forEach { subview in
            let fittingSize = subview.sizeThatFits(proposal)
            maxHeight = max(maxHeight, fittingSize.height)
        }

        var rows = [Row(heigh: maxHeight)]
        var rowIndex = 0
        
        subviews.forEach(){ subview in
            let subviewSize = subview.sizeThatFits(proposal)
            
            if subviewSize.width + rows[rowIndex].width > proposaWidth {
                rows.append(Row(heigh: maxHeight))
                currentY = currentY + maxHeight + vSpacing
                rowIndex+=1
            }
            
            rows[rowIndex].elementCGRects.append(CGRect(
                x: rows[rowIndex].width + hSpacing,
                y: currentY,
                width: subviewSize.width,
                height: maxHeight))
            
        }
        
        return rows
    }
    
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let rows = getRow(subviews: subviews, proposaWidth: proposal.width)
        let maxWidth: CGFloat = rows.reduce(.zero){(currentMaxWidth, row) -> CGFloat in return max(currentMaxWidth, row.width + hSpacing ) }
        let maxHeight: CGFloat = rows[0].heigh + vSpacing
        
        return CGSize(width: maxWidth,
                      height: maxHeight * CGFloat(rows.count) + vSpacing)
    }


    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let rows = getRow(subviews: subviews, proposaWidth: proposal.width)
        var index = 0
        
        rows.forEach(){ row in
            row.elementCGRects.forEach(){ elementCGRect in
                let subview = subviews[index]
                defer { index += 1 }
                
                subview.place(at: CGPoint(x: elementCGRect.minX + bounds.minX,
                                          y: elementCGRect.minY + bounds.minY),
                              proposal: ProposedViewSize(width: elementCGRect.width,
                                                         height: elementCGRect.height))
                
            }
        }
    }
}



#Preview {
    @State var storeInfoModel = StoreInfoModel(stores: [store1] )
    //@State var storeInfoModel = StoreInfoModel(stores: [] )
    var store: Store = storeInfoModel.stores[0]
    return aa(store: store)
}

struct aa: View {
    var store: Store
    
    var body: some View {
        VStack{
            autoArrayLayoutView{
                ForEach(store.tags) { item in
                    typeView(type: item.tag, typeImage: "questionmark.app.dashed")
                }
            }
            .border(Color.red, width: 2)
        }
    }
}

